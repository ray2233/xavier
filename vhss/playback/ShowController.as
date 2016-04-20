package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.audio.*;
    import com.oddcast.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import vhss.*;
    import vhss.api.*;
    import vhss.api.requests.*;
    import vhss.events.*;
    import vhss.reports.*;
    import vhss.structures.*;
    import vhss.util.*;

    public class ShowController extends Sprite
    {
        private var show_data:SlideShowStruct;
        private var scene_data:SceneStruct;
        private var host_data:HostStruct;
        private var bg_data:BackgroundStruct;
        private var loader_holder:AssetHolder;
        private var watermark_holder:AssetHolder;
        private var host_holder:HostHolder;
        private var bg_holder:BackgroundHolder;
        private var bg_tile:Sprite;
        private var masked_items_holder:Sprite;
        private var skin_holder:SkinHolder;
        private var link_data:LinkStruct;
        private var link_timer:Timer;
        private var is_interrupt:Boolean = false;
        private var is_speaking:Boolean = false;
        private var assets_to_load:int;
        private var audio_by_name:AudioRequestQueue;
        private var bg_by_name:BGRequester;
        private var ai_by_php:AIRequester;
        private var lead_sender:LeadSender;
        private var scene_volume:Number = 1;
        private var scene_volume_before_mute:Number = 1;
        private var vhss_shared_object:VHSSSharedObject;
        private var is_auto_advance:Boolean = false;
        private var gaze_ctrl:GazeController;
        private var bad_word_filter:BadWordFilter;
        private var loading_status:String = "loaded";
        private var auto_adv_timer:Timer;
        private var active_scene_index:int = -1;
        private var next_index_from_api:int = -1;
        private var preload_scene_index:int;
        private var bg_color:Number;
        private var hack_audio_request:APITTSRequest;
        private static const STATUS_LOADED:String = "loaded";
        private static const STATUS_LOADING:String = "loading";
        private static const STATUS_PRELOADING:String = "preloading";

        public function ShowController(param1:SlideShowStruct, param2:Number = 16777215) : void
        {
            bad_word_filter = new BadWordFilter(param1.account_id);
            show_data = param1;
            if (show_data.account_id != null && show_data.show_id != null && Constants.EMBED_ID != null)
            {
                vhss_shared_object = new VHSSSharedObject(show_data.account_id, show_data.show_id, Constants.EMBED_ID);
            }
            masked_items_holder = new Sprite();
            addChild(masked_items_holder);
            bg_tile = new Sprite();
            bg_color = isNaN(param2) ? (-1) : (param2);
            if (param1.bg_color != null)
            {
                bg_color = isNaN(parseInt(param1.bg_color)) ? (-1) : (parseInt(param1.bg_color));
            }
            bg_tile.graphics.beginFill(bg_color, bg_color == -1 ? (0) : (1));
            bg_tile.graphics.drawRect(0, 0, 400, 300);
            masked_items_holder.addChild(bg_tile);
            bg_holder = new BackgroundHolder();
            bg_holder.addEventListener(Event.COMPLETE, e_playbackComplete);
            bg_holder.addEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
            masked_items_holder.addChild(bg_holder);
            host_holder = new HostHolder();
            host_holder.addEventListener(VHSSEvent.AUDIO_ENDED, e_dispatchEvent);
            host_holder.addEventListener(VHSSEvent.AUDIO_STARTED, e_dispatchEvent);
            host_holder.addEventListener(VHSSEvent.TALK_ENDED, e_talkEnded);
            host_holder.addEventListener(VHSSEvent.TALK_STARTED, e_talkStarted);
            host_holder.addEventListener(VHSSEvent.CONFIG_DONE, e_dispatchEvent);
            host_holder.addEventListener(VHSSEvent.ENGINE_LOADED, e_dispatchEvent);
            host_holder.addEventListener(VHSSEvent.MODEL_LOAD_ERROR, e_dispatchEvent);
            host_holder.addEventListener(VHSSEvent.AUDIO_ERROR, e_dispatchEvent);
            host_holder.addEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
            gaze_ctrl = new GazeController(host_holder);
            masked_items_holder.addChild(host_holder);
            skin_holder = new SkinHolder();
            configureSkinListeners();
            addChild(skin_holder);
            return;
        }// end function

        private function configureSkinListeners() : void
        {
            skin_holder.addEventListener(SkinEvent.PLAY, e_skinPlay);
            skin_holder.addEventListener(SkinEvent.MUTE, e_skinMute);
            skin_holder.addEventListener(SkinEvent.SAY_AI, e_skinSayAI);
            skin_holder.addEventListener(SkinEvent.SAY_FAQ, e_skinSayFAQ);
            skin_holder.addEventListener(SkinEvent.SEND_LEAD, e_skinLeadSend);
            skin_holder.addEventListener(SkinEvent.PAUSE, e_skinPause);
            skin_holder.addEventListener(SkinEvent.UNMUTE, e_skinUnmute);
            skin_holder.addEventListener(SkinEvent.VOLUME_CHANGE, e_skinVolume);
            skin_holder.addEventListener(SkinEvent.NEXT, e_skinNext);
            skin_holder.addEventListener(SkinEvent.PREV, e_skinPrev);
            skin_holder.addEventListener(SkinEvent.LEAD_ERROR, e_skinLeadAudio);
            skin_holder.addEventListener(SkinEvent.LEAD_SUCCESS, e_skinLeadAudio);
            skin_holder.addEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
            return;
        }// end function

        private function assetLoaded() : void
        {
            var _loc_3:* = assets_to_load - 1;
            assets_to_load = _loc_3;
            if (assets_to_load == 0)
            {
                var onBadWordsLoaded:* = function () : void
            {
                var vol:Number;
                if (loading_status == STATUS_PRELOADING)
                {
                    try
                    {
                        ExternalInterface.call("VHSS_Command", "vh_scenePreloaded", (preload_scene_index + 1));
                    }
                    catch ($e:Error)
                    {
                    }
                    dispatchEvent(new VHSSEvent(VHSSEvent.SCENE_PRELOADED, {scene_number:(preload_scene_index + 1)}));
                    loading_status = STATUS_LOADED;
                }
                else
                {
                    if (loader_holder != null)
                    {
                        removeChild(loader_holder);
                        loader_holder = null;
                    }
                    stopSpeech();
                    host_holder.displayAsset(scene_data.host);
                    host_holder.followCursor(scene_data.mouse_follow);
                    try
                    {
                        if (stage != null)
                        {
                            gaze_ctrl.setStageReference(stage);
                            gaze_ctrl.followInPage(scene_data.mouse_follow == 4);
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    host_holder.x = scene_data.host_x;
                    host_holder.y = scene_data.host_y;
                    host_holder.visible = scene_data.host_visible;
                    var _loc_2:* = scene_data.host_scale * 0.01;
                    host_holder.scaleY = scene_data.host_scale * 0.01;
                    host_holder.scaleX = _loc_2;
                    if (scene_data.host_exp)
                    {
                        host_holder.setFacialExpByString(scene_data.host_exp, -1, scene_data.host_exp_intensity);
                    }
                    if (scene_data.skin)
                    {
                        skin_holder.displayAsset(scene_data.skin);
                        setSkinFeatures();
                    }
                    else
                    {
                        if (watermark_holder)
                        {
                            watermark_holder.x = 50;
                        }
                        if (watermark_holder)
                        {
                            watermark_holder.y = 50;
                        }
                    }
                    bg_holder.displayAsset(scene_data.bg);
                    bg_holder.scaleX = scene_data.backgroundTransform.scaleX;
                    bg_holder.scaleY = scene_data.backgroundTransform.scaleY;
                    loading_status = STATUS_LOADED;
                    if (show_data.volume > -1)
                    {
                        vol = show_data.volume / Constants.VOLUME_RANGE_PLAYER.max;
                        show_data.volume = -1;
                        setVolume(vol);
                    }
                    startScene();
                }
                return;
            }// end function
            ;
                if (Constants.IS_FILTERED)
                {
                    bad_word_filter.load(onBadWordsLoaded, _onBadWordsError);
                }
                else
                {
                    this.onBadWordsLoaded();
                }
            }
            return;
        }// end function

        private function startScene() : void
        {
            VHSSPlayerTracker.event("sv", scene_data.id);
            dispatchEvent(new VHSSEvent(VHSSEvent.SCENE_LOADED, {scene_number:(active_scene_index + 1)}));
            setVolume(scene_volume);
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_sceneLoaded", (active_scene_index + 1));
                }
                catch ($e:Error)
                {
                }
            }
            if (scene_data.play_mode.indexOf("click") != -1 && !Constants.SUPPRESS_PLAY_ON_CLICK)
            {
                host_holder.addEventListener(MouseEvent.CLICK, e_playOnClick);
            }
            if (!Constants.SUPPRESS_PLAY_ON_LOAD)
            {
                if (scene_data.play_mode.indexOf("load") != -1)
                {
                    if (isPlayable())
                    {
                        saySceneAudio();
                    }
                }
                if (scene_data.play_mode.indexOf("ro") != -1)
                {
                    host_holder.addEventListener(MouseEvent.ROLL_OVER, e_playOnRO);
                }
            }
            else
            {
                sceneComplete();
            }
            return;
        }// end function

        private function isPlayable() : Boolean
        {
            if (vhss_shared_object != null && show_data.scenes.length == 1)
            {
                try
                {
                    return vhss_shared_object.isPlayable(scene_data.audio.id.toString(), scene_data.playback_limit, scene_data.playback_interval);
                }
                catch ($e:Error)
                {
                    return true;
                }
            }
            return true;
        }// end function

        private function sceneComplete() : void
        {
            dispatchEvent(new VHSSEvent(VHSSEvent.SCENE_PLAYBACK_COMPLETE));
            if (is_auto_advance && (next_index_from_api > -1 || active_scene_index < (show_data.scenes.length - 1)))
            {
                auto_adv_timer = new Timer(scene_data.advance_delay * 1000, 1);
                auto_adv_timer.addEventListener(TimerEvent.TIMER_COMPLETE, e_onAutoAdvance);
                auto_adv_timer.start();
            }
            return;
        }// end function

        private function setMute(param1:Boolean) : void
        {
            if (param1)
            {
                scene_volume_before_mute = scene_volume;
            }
            setVolume(param1 ? (0) : (scene_volume_before_mute), false);
            return;
        }// end function

        private function createAudioRequester() : void
        {
            audio_by_name = new AudioRequestQueue();
            audio_by_name.addEventListener(APIEvent.SAY_AUDIO_URL, e_audioURLReady);
            audio_by_name.addEventListener(APIEvent.AUDIO_CACHED, e_audioCached);
            return;
        }// end function

        private function resume() : void
        {
            bg_holder.resume();
            host_holder.resume();
            if (is_speaking || bg_holder.getStatus() == "paused")
            {
                skin_holder.activatePauseButton();
            }
            return;
        }// end function

        private function pause() : void
        {
            bg_holder.pause();
            host_holder.freeze();
            if (is_speaking || bg_holder.getStatus() == "playing")
            {
                skin_holder.activatePlayButton();
            }
            return;
        }// end function

        private function setSkinFeatures() : void
        {
            var _loc_1:Object = null;
            if (watermark_holder != null)
            {
                _loc_1 = skin_holder.getWatermarkPosition();
                if (_loc_1.x != null)
                {
                    watermark_holder.x = _loc_1.x;
                }
                if (_loc_1.y != null)
                {
                    watermark_holder.y = _loc_1.y;
                }
                watermark_holder.visible = _loc_1.x != null && _loc_1.x > 0;
            }
            if (skin_holder.getSkinMask() != null)
            {
                masked_items_holder.mask = skin_holder.getSkinMask();
            }
            else
            {
                masked_items_holder.mask = null;
            }
            if (scene_data.skin_conf != null)
            {
                skin_holder.configureSkin(scene_data.skin_conf);
            }
            return;
        }// end function

        private function setAutoLink() : void
        {
            if (link_data.auto_delay > 0)
            {
                link_timer = new Timer(link_data.auto_delay, 1);
                link_timer.addEventListener(TimerEvent.TIMER_COMPLETE, e_openSceneLink);
                link_timer.start();
            }
            else
            {
                e_openSceneLink();
            }
            return;
        }// end function

        public function init() : void
        {
            var watermarkStatus:int;
            if (show_data)
            {
                watermarkStatus;
                if (show_data.watermark_url != null)
                {
                    watermark_holder = new AssetHolder("watermark");
                    addChild(watermark_holder);
                    watermark_holder.visible = false;
                    watermark_holder.addEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                    watermark_holder.loadAsset(new LoadedAssetStruct(show_data.watermark_url, 0, "watermark"));
                    watermarkStatus;
                }
                else if (show_data.loader_url)
                {
                    watermarkStatus;
                }
                setTimeout(function () : void
            {
                setWatermarkCookie(watermarkStatus);
                return;
            }// end function
            , 1000);
                if (show_data.loader_url != null)
                {
                    loader_holder = new AssetHolder("loader");
                    addChild(loader_holder);
                    loader_holder.addEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                    loader_holder.loadAsset(new LoadedAssetStruct(show_data.loader_url, 0, "loader"));
                }
                else
                {
                    displayScene();
                    startTracker();
                }
            }
            else
            {
                throw new Error("Missing data for scene or show. Please make sure you are using a valid index.");
            }
            return;
        }// end function

        private function setWatermarkCookie(param1:int) : void
        {
            var watermarkLoader:URLLoader;
            var onWatermarkComplete:Function;
            var onWatermarkSecurityError:Function;
            var watermarkStatus:* = param1;
            onWatermarkComplete = function (event:Event) : void
            {
                watermarkLoader.removeEventListener(Event.COMPLETE, onWatermarkComplete);
                watermarkLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onWatermarkSecurityError);
                return;
            }// end function
            ;
            onWatermarkSecurityError = function (event:SecurityErrorEvent) : void
            {
                watermarkLoader.removeEventListener(Event.COMPLETE, onWatermarkComplete);
                watermarkLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onWatermarkSecurityError);
                return;
            }// end function
            ;
            var vars:* = new URLVariables();
            vars.internalmode = Constants.INTERNAL_MODE;
            vars.watermark = watermarkStatus;
            var url:* = Constants.SITEPAL_BASE + Constants.SET_COOKIE_PHP + "?" + vars.toString();
            watermarkLoader = new URLLoader();
            watermarkLoader.addEventListener(Event.COMPLETE, onWatermarkComplete);
            watermarkLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onWatermarkSecurityError);
            watermarkLoader.load(new URLRequest(url));
            return;
        }// end function

        public function displayScene(param1:int = 0) : void
        {
            if (param1 >= 0 && param1 <= (show_data.scenes.length - 1) && param1 != active_scene_index && loading_status == STATUS_LOADED)
            {
                loading_status = STATUS_LOADING;
                active_scene_index = param1;
                scene_data = SceneStruct(show_data.scenes[param1]);
                is_auto_advance = scene_data.auto_advance && !Constants.SUPPRESS_AUTO_ADV;
                assets_to_load = scene_data.assets_to_load;
                if (scene_data.host)
                {
                    loadHost(HostStruct(scene_data.host));
                }
                if (scene_data.bg)
                {
                    loadBg(BackgroundStruct(scene_data.bg));
                }
                if (scene_data.skin)
                {
                    loadSkin(SkinStruct(scene_data.skin));
                }
                setLink(scene_data.link);
            }
            return;
        }// end function

        public function preloadScene(param1:int) : void
        {
            var _loc_2:SceneStruct = null;
            if (param1 >= 0 && param1 <= (show_data.scenes.length - 1) && loading_status == STATUS_LOADED)
            {
                loading_status = STATUS_PRELOADING;
                preload_scene_index = param1;
                _loc_2 = SceneStruct(show_data.scenes[param1]);
                assets_to_load = _loc_2.assets_to_load;
                loadHost(HostStruct(_loc_2.host));
                if (_loc_2.bg != null)
                {
                    loadBg(BackgroundStruct(_loc_2.bg));
                }
                if (_loc_2.skin != null)
                {
                    loadSkin(SkinStruct(_loc_2.skin));
                }
            }
            return;
        }// end function

        public function saySceneAudio() : void
        {
            if (scene_data.audio != null && scene_data.audio.url != null)
            {
                sayAudio(scene_data.audio.url);
            }
            else if (bg_holder.getStatus().length > 0)
            {
                bg_holder.replay();
                skin_holder.activatePauseButton();
            }
            else
            {
                skin_holder.activatePlayButton();
                dispatchEvent(new VHSSEvent(VHSSEvent.SCENE_PLAYBACK_COMPLETE));
            }
            return;
        }// end function

        public function startTracker() : void
        {
            var _track_obj:Object;
            if (show_data.track_url != null)
            {
                _track_obj = new Object();
                if (show_data.scenes.length == 1)
                {
                    _track_obj["scn"] = SceneStruct(show_data.scenes[0]).id;
                }
                _track_obj["apt"] = "v";
                _track_obj["acc"] = show_data.account_id;
                _track_obj["emb"] = Constants.TRACKING_EMBED_ID;
                if (show_data.show_id.length > 0)
                {
                    _track_obj["shw"] = show_data.show_id;
                }
                if (Constants.PAGE_DOMAIN != null)
                {
                    _track_obj["dom"] = Constants.PAGE_DOMAIN;
                }
                try
                {
                    _track_obj["skn"] = scene_data.skin.id;
                }
                catch ($err:Error)
                {
                }
                if (show_data.track_url != null && show_data.track_url.length() > 0 && !Constants.SUPPRESS_TRACKING)
                {
                    VHSSPlayerTracker.initTracker(show_data.track_url, _track_obj, this.loaderInfo);
                    VHSSPlayerTracker.event("fver", null, 0, Constants.FLASH_PLAYER_VERSION);
                }
            }
            return;
        }// end function

        public function getActiveEngineAPI() : Object
        {
            return host_holder.getActiveEngineAPI();
        }// end function

        public function setHostPosition(param1:int, param2:int, param3:int) : void
        {
            host_holder.x = param1;
            host_holder.y = param2;
            var _loc_4:* = param3 * 0.01;
            host_holder.scaleY = param3 * 0.01;
            host_holder.scaleX = _loc_4;
            return;
        }// end function

        public function getHostHolder() : HostHolder
        {
            return host_holder;
        }// end function

        public function getBGHolder() : BackgroundHolder
        {
            return bg_holder;
        }// end function

        public function setSkinConfig(param1:XML) : void
        {
            scene_data.skin_conf = param1;
            setSkinFeatures();
            return;
        }// end function

        public function filterTTS(param1:String, param2:String) : String
        {
            return bad_word_filter != null && Constants.IS_FILTERED && bad_word_filter.isReady ? (bad_word_filter.filter(param1, param2)) : (param1);
        }// end function

        public function setSceneAudio(param1:AudioStruct) : void
        {
            scene_data.audio = param1;
            return;
        }// end function

        public function freezeToggle() : void
        {
            if (host_holder.getIsFrozen())
            {
                resume();
            }
            else
            {
                pause();
            }
            return;
        }// end function

        public function followCursor(param1:Number) : void
        {
            host_holder.followCursor(param1);
            gaze_ctrl.followInPage(param1 == 2);
            return;
        }// end function

        public function setGaze(param1:Number, param2:Number, param3:Number = 100, param4:Number = 0) : void
        {
            if (gaze_ctrl)
            {
                if (param4 == 1)
                {
                    gaze_ctrl.setGazePage(param1, param2, param3);
                }
                else
                {
                    gaze_ctrl.setGazeUser(param1, param2, param3);
                }
            }
            return;
        }// end function

        public function setFacialExpression(param1, param2:Number, param3:Number, param4:Number, param5:Number) : void
        {
            if (isNaN(param1))
            {
                host_holder.setFacialExpByString(String(param1), param2, param3, param4, param5);
            }
            else
            {
                host_holder.setFacialExpById(Number(param1), param2, param3, param4, param5);
            }
            return;
        }// end function

        public function sayAudio(param1:String, param2:Number = 0) : void
        {
            resume();
            if (is_interrupt)
            {
                stopSpeech();
            }
            host_holder.sayAudio(param1, param2);
            return;
        }// end function

        public function sayText(param1:APITTSRequest) : void
        {
            CachedTTS.setDomain(Constants.TTS_DOMAIN);
            if (Constants.IS_FILTERED && !(param1 is APIAIRequest))
            {
                param1.name = filterTTS(param1.name, param1.lang);
            }
            var _loc_2:* = CachedTTS.getTTSURL(param1.name, parseInt(param1.voice), parseInt(param1.lang), parseInt(param1.engine), param1.fx_type, parseInt(param1.fx_level));
            var _loc_3:* = (param1.engine.length < 2 ? ("0" + param1.engine) : (param1.engine)) + (param1.lang.length < 2 ? ("0" + param1.lang) : (param1.lang)) + (param1.voice.length < 2 ? ("0" + param1.voice) : (param1.voice));
            VHSSPlayerTracker.event("actts", scene_data.id, 0, _loc_3);
            hack_audio_request = param1;
            sayAudio(_loc_2);
            return;
        }// end function

        public function sayAIResponse(param1:APIAIRequest) : void
        {
            if (ai_by_php == null)
            {
                ai_by_php = new AIRequester();
                ai_by_php.addEventListener(APIEvent.AI_COMPLETE, e_aiComplete);
            }
            param1.account_id = show_data.account_id;
            param1.ai_engine_id = show_data.ai_engine_id;
            ai_by_php.load(param1);
            return;
        }// end function

        public function sayMultiple(param1:Array) : void
        {
            host_holder.sayMultiple(param1);
            return;
        }// end function

        public function sayByNameExported(param1:APIAudioRequest) : void
        {
            if (audio_by_name == null)
            {
                createAudioRequester();
            }
            sayByName(param1);
            return;
        }// end function

        public function sayByName(param1:APIAudioRequest) : void
        {
            if (audio_by_name == null)
            {
                createAudioRequester();
            }
            param1.account_id = show_data.account_id;
            audio_by_name.load(param1);
            return;
        }// end function

        public function setVolume(param1:Number, param2:Boolean = true) : void
        {
            scene_volume = param1;
            host_holder.setVolume(param1);
            bg_holder.setVolume(param1);
            if (param2)
            {
                skin_holder.setVolumeSlider(param1);
            }
            return;
        }// end function

        public function setBackground(param1:APIRequest) : void
        {
            if (bg_by_name == null)
            {
                bg_by_name = new BGRequester();
                bg_by_name.addEventListener(APIEvent.BG_URL, e_bgUrlReady);
            }
            param1.account_id = show_data.account_id;
            bg_by_name.load(param1);
            return;
        }// end function

        public function setColor(param1:String, param2:uint) : void
        {
            host_holder.setColor(param1, param2);
            return;
        }// end function

        public function loadHost(param1:HostStruct, param2:Boolean = false) : void
        {
            if (param2)
            {
                host_holder.addEventListener(AssetEvent.ASSET_INIT, e_displayImmediately, false, 1);
            }
            host_holder.loadAsset(param1);
            return;
        }// end function

        public function gotoNextScene() : void
        {
            if (auto_adv_timer != null)
            {
                auto_adv_timer.stop();
                auto_adv_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_onAutoAdvance);
            }
            is_auto_advance = false;
            stopSpeech();
            if (next_index_from_api != -1)
            {
                displayScene(next_index_from_api);
            }
            else
            {
                displayScene((active_scene_index + 1));
            }
            next_index_from_api = -1;
            return;
        }// end function

        public function preloadNextScene() : void
        {
            preloadScene((active_scene_index + 1));
            return;
        }// end function

        public function gotoPrevScene() : void
        {
            if (auto_adv_timer != null)
            {
                auto_adv_timer.stop();
                auto_adv_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_onAutoAdvance);
            }
            is_auto_advance = false;
            stopSpeech();
            displayScene((active_scene_index - 1));
            return;
        }// end function

        public function gotoScene(param1:int) : void
        {
            displayScene((param1 - 1));
            return;
        }// end function

        public function setNextSceneIndex(param1:int) : void
        {
            next_index_from_api = param1 - 1;
            return;
        }// end function

        public function stopSpeech() : void
        {
            bg_holder.stop();
            host_holder.stopSpeech();
            skin_holder.activatePlayButton();
            return;
        }// end function

        public function replay(param1:Boolean) : void
        {
            if (param1 || isPlayable())
            {
                saySceneAudio();
            }
            return;
        }// end function

        public function setInterrupt(param1:Number) : void
        {
            is_interrupt = param1 == 1;
            return;
        }// end function

        public function loadBg(param1:BackgroundStruct, param2:Boolean = false, param3:Object = null) : void
        {
            var $bs:* = param1;
            var $display:* = param2;
            var transform:* = param3;
            if ($display)
            {
                bg_holder.addEventListener(AssetEvent.ASSET_INIT, e_displayImmediately, false, 1);
            }
            if (transform)
            {
                with ({})
                {
                    {}.onInit = function (event:AssetEvent) : void
            {
                bg_holder.removeEventListener(AssetEvent.ASSET_INIT, onInit);
                setBackgroundTransform(transform);
                return;
            }// end function
            ;
                }
                bg_holder.addEventListener(AssetEvent.ASSET_INIT, function (event:AssetEvent) : void
            {
                bg_holder.removeEventListener(AssetEvent.ASSET_INIT, onInit);
                setBackgroundTransform(transform);
                return;
            }// end function
            );
            }
            bg_holder.loadAsset($bs);
            return;
        }// end function

        public function setBackgroundTransform(param1:Object) : void
        {
            scene_data.backgroundTransform = param1;
            var _loc_2:* = scene_data.backgroundTransform;
            bg_holder.x = _loc_2.x;
            bg_holder.y = _loc_2.y;
            bg_holder.rotation = _loc_2.rotation;
            bg_holder.scaleX = _loc_2.scaleX;
            bg_holder.scaleY = _loc_2.scaleY;
            return;
        }// end function

        public function setLookSpeed(param1:String) : void
        {
            host_holder.setLookSpeed(param1);
            return;
        }// end function

        public function setRandomMovement(param1:String) : void
        {
            host_holder.setRandomMovement(param1);
            return;
        }// end function

        public function setSpeechMovement(param1:Number) : void
        {
            host_holder.setSpeechMovement(param1);
            return;
        }// end function

        private function loadSkin(param1:SkinStruct, param2:Boolean = false) : void
        {
            if (param2)
            {
                skin_holder.addEventListener(AssetEvent.ASSET_INIT, e_displayImmediately, false, 1);
            }
            skin_holder.loadAsset(param1);
            return;
        }// end function

        public function loadSkinFromAPI(param1:SkinStruct, param2:Boolean = false) : void
        {
            var _loc_3:int = 0;
            while (_loc_3 < show_data.scenes.length)
            {
                
                if (SceneStruct(show_data.scenes[_loc_3]).skin)
                {
                    var _loc_4:* = SceneStruct(show_data.scenes[_loc_3]);
                    var _loc_5:* = SceneStruct(show_data.scenes[_loc_3]).assets_to_load - 1;
                    _loc_4.assets_to_load = _loc_5;
                }
                SceneStruct(show_data.scenes[_loc_3]).skin = param1;
                _loc_3++;
            }
            loadSkin(param1, param2);
            return;
        }// end function

        public function setLink(param1:LinkStruct) : void
        {
            if (link_data == null || param1 == null)
            {
                link_data = param1;
            }
            else
            {
                link_data.url = param1.url;
                if (param1.target != null)
                {
                    link_data.target = param1.target;
                }
            }
            if (link_timer != null)
            {
                link_timer.stop();
                link_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_openSceneLink);
            }
            if (link_data != null && link_data.is_button_launch)
            {
                masked_items_holder.addEventListener(MouseEvent.CLICK, e_openSceneLink);
            }
            else
            {
                masked_items_holder.removeEventListener(MouseEvent.CLICK, e_openSceneLink);
            }
            return;
        }// end function

        public function getShowXML() : XML
        {
            return show_data.show_xml;
        }// end function

        public function getAudioUrl() : String
        {
            return scene_data.audio != null && scene_data.audio.url != null ? (scene_data.audio.url) : (null);
        }// end function

        public function displayBgFrame(param1:Number = 0) : void
        {
            bg_holder.displayBgFrame(param1);
            return;
        }// end function

        public function setRandomMovementParameters(param1:Number, param2:Number) : void
        {
            host_holder.setRandomMovementParameters(param1, param2);
            return;
        }// end function

        private function e_audioURLReady(event:APIEvent) : void
        {
            var _loc_2:* = APIAudioRequest(event.data);
            sayAudio(_loc_2.url, _loc_2.start_time);
            return;
        }// end function

        private function e_audioCached(event:APIEvent) : void
        {
            var $ev:* = event;
            try
            {
                ExternalInterface.call("VHSS_Command", "vh_audioLoaded", APIAudioRequest($ev.data).name);
            }
            catch ($e:Error)
            {
            }
            var t_ve:* = new VHSSEvent(VHSSEvent.AUDIO_LOADED);
            t_ve.data = APIAudioRequest($ev.data).name;
            dispatchEvent(t_ve);
            return;
        }// end function

        private function e_bgUrlReady(event:APIEvent) : void
        {
            var _loc_2:* = BackgroundStruct(event.data);
            loadBg(_loc_2, true);
            return;
        }// end function

        private function e_aiComplete(event:APIEvent) : void
        {
            var _loc_2:* = event.data as AIResponse;
            stopSpeech();
            if (_loc_2.url != null && _loc_2.url.length > 1)
            {
                sayAudio(_loc_2.url);
            }
            else
            {
                sayText(_loc_2.ai_request);
            }
            var _loc_3:* = _loc_2.display_text.length > 0 ? (_loc_2.display_text) : (_loc_2.ai_request.name);
            skin_holder.setAIResponse(_loc_3);
            dispatchEvent(event);
            return;
        }// end function

        private function _onBadWordsLoaded() : void
        {
            assetLoaded();
            return;
        }// end function

        private function _onBadWordsError() : void
        {
            throw new Error("Configuration indicated that bad words should be filtered, but bad words xml was not able to load from url:" + bad_word_filter.wordsXmlUrl);
        }// end function

        private function e_assetLoaded(event:AssetEvent) : void
        {
            var t_mc:MovieClip;
            var t_ct:ColorTransform;
            var $ev:* = event;
            var t_las:* = LoadedAssetStruct($ev.data);
            if (t_las.loader != null && t_las.loader.contentLoaderInfo.contentType == "application/x-shockwave-flash")
            {
                if (t_las.loader.contentLoaderInfo.swfVersion < 9)
                {
                    dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, true, "SWF version " + t_las.loader.contentLoaderInfo.swfVersion + " url: " + t_las.loader.contentLoaderInfo.url));
                }
            }
            if ($ev.data is BackgroundStruct)
            {
                assetLoaded();
                dispatchEvent(new VHSSEvent(VHSSEvent.BG_LOADED));
            }
            else if ($ev.data is SkinStruct)
            {
                assetLoaded();
                dispatchEvent(new VHSSEvent(VHSSEvent.SKIN_LOADED));
            }
            else if ($ev.data is HostStruct)
            {
                assetLoaded();
            }
            else if ($ev.data.type == "loader")
            {
                try
                {
                    t_mc = MovieClip(LoadedAssetStruct($ev.data).display_obj).loadingAnim.bg;
                    if (bg_color == -1)
                    {
                        t_mc.alpha = 0;
                    }
                    else
                    {
                        t_ct = new ColorTransform();
                        t_ct.color = bg_color;
                        t_mc.transform.colorTransform = t_ct;
                    }
                }
                catch ($e:Error)
                {
                }
                loader_holder.displayAsset(t_las);
                loader_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                displayScene();
                startTracker();
            }
            else if ($ev.data.type == "watermark")
            {
                watermark_holder.displayAsset(t_las);
                watermark_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
            }
            return;
        }// end function

        private function e_displayImmediately(event:AssetEvent) : void
        {
            var _loc_2:BackgroundStruct = null;
            if (event.data is BackgroundStruct)
            {
                _loc_2 = BackgroundStruct(event.data);
                bg_holder.displayAsset(_loc_2);
                var _loc_3:* = _loc_2.type == "video" ? (Constants.FLV_SCALE_DEFAULT) : (Constants.BG_SCALE_DEFAULT);
                bg_holder.scaleY = _loc_2.type == "video" ? (Constants.FLV_SCALE_DEFAULT) : (Constants.BG_SCALE_DEFAULT);
                bg_holder.scaleX = _loc_3;
                bg_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
            }
            else if (event.data is SkinStruct)
            {
                if (event.data.url == null)
                {
                    masked_items_holder.mask = null;
                }
                skin_holder.displayAsset(SkinStruct(event.data));
                skin_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
            }
            else if (event.data is HostStruct)
            {
                host_holder.displayAsset(HostStruct(event.data));
                host_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
            }
            return;
        }// end function

        private function e_dispatchEvent(event:VHSSEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function e_talkStarted(event:VHSSEvent) : void
        {
            var _loc_2:String = null;
            is_speaking = true;
            if (hack_audio_request is APITTSRequest)
            {
                _loc_2 = (hack_audio_request.engine.length < 2 ? ("0" + hack_audio_request.engine) : (hack_audio_request.engine)) + (hack_audio_request.lang.length < 2 ? ("0" + hack_audio_request.lang) : (hack_audio_request.lang)) + (hack_audio_request.voice.length < 2 ? ("0" + hack_audio_request.voice) : (hack_audio_request.voice));
                hack_audio_request = null;
                VHSSPlayerTracker.event("aptts", scene_data.id, 0, _loc_2);
            }
            else
            {
                VHSSPlayerTracker.event("ap", scene_data.id);
            }
            bg_holder.replay();
            skin_holder.activatePauseButton();
            dispatchEvent(event);
            if (link_data != null && link_data.is_start_launch)
            {
                setAutoLink();
            }
            return;
        }// end function

        private function e_talkEnded(event:VHSSEvent) : void
        {
            is_speaking = false;
            VHSSPlayerTracker.event("ae", scene_data.id);
            if (bg_holder.getStatus() != "playing")
            {
                skin_holder.activatePlayButton();
                sceneComplete();
            }
            dispatchEvent(event);
            if (link_data != null && link_data.is_end_launch)
            {
                setAutoLink();
            }
            return;
        }// end function

        private function e_playbackComplete(event:Event) : void
        {
            if (!is_speaking)
            {
                skin_holder.activatePlayButton();
                sceneComplete();
            }
            return;
        }// end function

        private function e_onAutoAdvance(event:TimerEvent) : void
        {
            gotoNextScene();
            return;
        }// end function

        private function e_openSceneLink(event:Event = null) : void
        {
            navigateToURL(new URLRequest(link_data.url), link_data.target);
            if (link_timer != null)
            {
                link_timer.stop();
                link_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_openSceneLink);
            }
            return;
        }// end function

        private function e_playOnClick(event:MouseEvent) : void
        {
            if (is_speaking)
            {
                freezeToggle();
            }
            else
            {
                saySceneAudio();
            }
            return;
        }// end function

        private function e_playOnRO(event:MouseEvent) : void
        {
            host_holder.removeEventListener(MouseEvent.ROLL_OVER, e_playOnRO);
            saySceneAudio();
            return;
        }// end function

        private function e_skinPlay(param1) : void
        {
            if (!is_speaking && bg_holder.getStatus() != "paused")
            {
                saySceneAudio();
            }
            else
            {
                resume();
            }
            VHSSPlayerTracker.event("uipl", scene_data.id);
            return;
        }// end function

        private function e_skinNext(event:SkinEvent) : void
        {
            gotoNextScene();
            return;
        }// end function

        private function e_skinPrev(event:SkinEvent) : void
        {
            gotoPrevScene();
            return;
        }// end function

        private function e_skinPause(param1) : void
        {
            pause();
            VHSSPlayerTracker.event("uips", scene_data.id);
            return;
        }// end function

        private function e_skinMute(param1) : void
        {
            setMute(true);
            VHSSPlayerTracker.event("uim", scene_data.id);
            return;
        }// end function

        private function e_skinUnmute(param1) : void
        {
            setMute(false);
            VHSSPlayerTracker.event("uium", scene_data.id);
            return;
        }// end function

        private function e_skinVolume(param1) : void
        {
            setVolume(param1.obj);
            return;
        }// end function

        private function e_skinSayAI(param1) : void
        {
            var _loc_2:APIAIRequest = null;
            if (String(param1.obj.text).length > 0 && param1.obj.voice > 0 && param1.obj.lang > 0 && param1.obj.engine > 0)
            {
                if (this.loaderInfo.url.indexOf("oddcast") != -1 && Constants.IS_AI_ENABLED)
                {
                    VHSSPlayerTracker.event("uiai", scene_data.id);
                    _loc_2 = new APIAIRequest(param1.obj.text, param1.obj.voice, param1.obj.lang, param1.obj.engine, param1.obj.bot);
                    sayAIResponse(_loc_2);
                }
            }
            return;
        }// end function

        private function e_skinSayFAQ(param1) : void
        {
            stopSpeech();
            VHSSPlayerTracker.event("uifaq", scene_data.id);
            var _loc_2:* = String(param1.obj).indexOf("http") == 0 ? (String(param1.obj)) : (show_data.content_dom + String(param1.obj));
            sayAudio(_loc_2);
            return;
        }// end function

        private function e_skinLeadSend(param1) : void
        {
            VHSSPlayerTracker.event("uild", scene_data.id);
            lead_sender = new LeadSender();
            lead_sender.addEventListener(DataLoaderEvent.ON_DATA_READY, e_leadSent);
            lead_sender.sendLead(param1.obj, show_data, scene_data);
            return;
        }// end function

        private function e_leadSent(event:DataLoaderEvent) : void
        {
            lead_sender.removeEventListener(DataLoaderEvent.ON_DATA_READY, e_leadSent);
            var _loc_2:* = XML(event.data.data);
            skin_holder.setLeadResponse(_loc_2.name() == "OK");
            return;
        }// end function

        private function e_skinLeadAudio(event:SkinEvent) : void
        {
            stopSpeech();
            var _loc_2:* = String(event.obj).indexOf("http") == 0 ? (String(event.obj)) : (show_data.content_dom + String(event.obj));
            sayAudio(_loc_2);
            return;
        }// end function

        public function destroy() : void
        {
            removeAllDOCs(this);
            masked_items_holder.removeEventListener(MouseEvent.CLICK, e_openSceneLink);
            host_holder.removeEventListener(MouseEvent.CLICK, e_playOnClick);
            host_holder.removeEventListener(MouseEvent.ROLL_OVER, e_playOnRO);
            if (host_holder != null)
            {
                host_holder.stopSpeech();
                host_holder.removeEventListener(VHSSEvent.AUDIO_ENDED, e_dispatchEvent);
                host_holder.removeEventListener(VHSSEvent.AUDIO_STARTED, e_dispatchEvent);
                host_holder.removeEventListener(VHSSEvent.TALK_ENDED, e_talkEnded);
                host_holder.removeEventListener(VHSSEvent.TALK_STARTED, e_talkStarted);
                host_holder.removeEventListener(VHSSEvent.CONFIG_DONE, e_dispatchEvent);
                host_holder.removeEventListener(VHSSEvent.ENGINE_LOADED, e_dispatchEvent);
                host_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                host_holder.removeEventListener(VHSSEvent.MODEL_LOAD_ERROR, e_dispatchEvent);
                host_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
                host_holder.removeEventListener(VHSSEvent.AUDIO_ERROR, e_dispatchEvent);
                try
                {
                    host_holder.destroy();
                }
                catch ($e)
                {
                }
            }
            if (skin_holder != null)
            {
                skin_holder.removeEventListener(SkinEvent.PLAY, e_skinPlay);
                skin_holder.removeEventListener(SkinEvent.MUTE, e_skinMute);
                skin_holder.removeEventListener(SkinEvent.SAY_AI, e_skinSayAI);
                skin_holder.removeEventListener(SkinEvent.SAY_FAQ, e_skinSayFAQ);
                skin_holder.removeEventListener(SkinEvent.SEND_LEAD, e_skinLeadSend);
                skin_holder.removeEventListener(SkinEvent.PAUSE, e_skinPause);
                skin_holder.removeEventListener(SkinEvent.UNMUTE, e_skinUnmute);
                skin_holder.removeEventListener(SkinEvent.VOLUME_CHANGE, e_skinVolume);
                skin_holder.removeEventListener(SkinEvent.NEXT, e_skinNext);
                skin_holder.removeEventListener(SkinEvent.PREV, e_skinPrev);
                skin_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                skin_holder.removeEventListener(SkinEvent.LEAD_ERROR, e_skinLeadAudio);
                skin_holder.removeEventListener(SkinEvent.LEAD_SUCCESS, e_skinLeadAudio);
                skin_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
                try
                {
                    skin_holder.destroy();
                }
                catch ($e)
                {
                }
                skin_holder = null;
            }
            if (bg_holder != null)
            {
                bg_holder.stop();
                bg_holder.removeEventListener(Event.COMPLETE, e_playbackComplete);
                bg_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                bg_holder.removeEventListener(AssetEvent.ASSET_INIT, e_displayImmediately);
                try
                {
                    bg_holder.destroy();
                }
                catch ($e)
                {
                }
                bg_holder = null;
            }
            if (loader_holder != null)
            {
                loader_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
            }
            if (auto_adv_timer != null)
            {
                auto_adv_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_onAutoAdvance);
                auto_adv_timer = null;
            }
            if (audio_by_name != null)
            {
                audio_by_name.removeEventListener(APIEvent.SAY_AUDIO_URL, e_audioURLReady);
                audio_by_name.removeEventListener(APIEvent.AUDIO_CACHED, e_audioCached);
            }
            if (ai_by_php != null)
            {
                ai_by_php.removeEventListener(APIEvent.AI_COMPLETE, e_aiComplete);
                ai_by_php = null;
            }
            if (bg_by_name != null)
            {
                bg_by_name.removeEventListener(APIEvent.BG_URL, e_bgUrlReady);
                bg_by_name = null;
            }
            if (lead_sender != null)
            {
                lead_sender.removeEventListener(DataLoaderEvent.ON_DATA_READY, e_leadSent);
                lead_sender = null;
            }
            if (gaze_ctrl != null)
            {
                gaze_ctrl.destroy();
                gaze_ctrl = null;
            }
            if (link_timer != null)
            {
                link_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_openSceneLink);
                link_timer = null;
            }
            if (bad_word_filter != null)
            {
                bad_word_filter.destroy();
                bad_word_filter = null;
            }
            if (watermark_holder != null)
            {
                watermark_holder.removeEventListener(AssetEvent.ASSET_INIT, e_assetLoaded);
                try
                {
                    watermark_holder.destroy();
                }
                catch ($e)
                {
                }
                watermark_holder = null;
            }
            show_data = null;
            scene_data = null;
            host_data = null;
            bg_data = null;
            link_data = null;
            if (vhss_shared_object != null)
            {
                try
                {
                    vhss_shared_object.destroy();
                }
                catch ($e)
                {
                }
                vhss_shared_object = null;
            }
            return;
        }// end function

        private function removeAllDOCs(param1:DisplayObjectContainer) : void
        {
            while (param1.numChildren > 0)
            {
                
                if (param1.getChildAt(0) is DisplayObjectContainer && DisplayObjectContainer(param1.getChildAt(0)).numChildren > 0)
                {
                    removeAllDOCs(DisplayObjectContainer(param1.getChildAt(0)));
                }
                param1.removeChildAt(0);
            }
            return;
        }// end function

    }
}
