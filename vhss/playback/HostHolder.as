package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.event.*;
    import com.oddcast.host.api.*;
    import com.oddcast.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.utils.*;
    import vhss.*;
    import vhss.events.*;
    import vhss.util.*;

    public class HostHolder extends AssetHolder
    {
        private const move_range_3d:Number = 1.8;
        private var engine_holder:EngineHolder;
        private var active_host_data:HostStruct;
        private var loading_host_data:HostStruct;
        private var active_engine_api:Object;
        private var Engine3d:Class;
        private var is_frozen:Boolean = false;
        private var timer_audio_progress:Timer;

        public function HostHolder() : void
        {
            setType("host");
            active_host_data = new HostStruct();
            engine_holder = new EngineHolder();
            engine_holder.addEventListener(AssetEvent.ASSET_INIT, e_engineLoaded);
            return;
        }// end function

        private function engineReady() : void
        {
            var t_api:MovieClip;
            var t_eng:LoadedAssetStruct;
            switch(loading_host_data.type)
            {
                case HostStruct.HOST_2D:
                {
                    t_api = MovieClip(getEngineAPI(loading_host_data));
                    t_api.addEventListener(EngineEvent.CONFIG_DONE, e_configDone_2d);
                    t_api.addEventListener(EngineEvent.TALK_ENDED, e_talkEnded);
                    t_api.addEventListener(EngineEvent.TALK_STARTED, e_talkStarted);
                    t_api.addEventListener(EngineEvent.AUDIO_ENDED, e_audioEnded);
                    t_api.addEventListener(EngineEvent.AUDIO_STARTED, e_audioStarted);
                    t_api.addEventListener(EngineEvent.AUDIO_ERROR, e_audioError);
                    t_api.addEventListener(EngineEvent.MODEL_LOAD_ERROR, e_modelLoadError);
                    try
                    {
                        t_api.addEventListener(EngineEvent.ACCESSORY_LOAD_ERROR, e_accessoryLoadError);
                    }
                    catch ($e)
                    {
                    }
                    loadHost2d();
                    break;
                }
                case HostStruct.HOST_3D:
                {
                    t_eng = loading_host_data.engine;
                    try
                    {
                        if (t_eng.loader.contentLoaderInfo.applicationDomain.hasDefinition("__main__4editor"))
                        {
                            Engine3d = t_eng.loader.contentLoaderInfo.applicationDomain.getDefinition("__main__4editor") as Class;
                        }
                        else
                        {
                            Engine3d = t_eng.loader.contentLoaderInfo.applicationDomain.getDefinition("__main__4host") as Class;
                        }
                    }
                    catch ($error:ReferenceError)
                    {
                    }
                    loadHost3d();
                    break;
                }
                default:
                {
                    dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, true, "OC Error: Host is not a known type. type: " + loading_host_data.type));
                    break;
                }
            }
            if (active_engine_api == null)
            {
                active_engine_api = getEngineAPI(loading_host_data);
            }
            dispatchEvent(new VHSSEvent(VHSSEvent.ENGINE_LOADED));
            return;
        }// end function

        private function getEngineAPI(param1:HostStruct) : Object
        {
            if (!param1)
            {
                return null;
            }
            if (param1.type == HostStruct.HOST_2D)
            {
                return engine_holder.getLoadedAsset(param1.engine.id.toString() + param1.engine.url).display_obj;
            }
            if (param1.type == HostStruct.HOST_3D)
            {
                return param1.host_container.getAPI();
            }
            return null;
        }// end function

        private function loadHost3d() : void
        {
            var _loc_1:* = loading_host_data;
            _loc_1.host_container = MovieClip(new Engine3d());
            _loc_1.host_container.init(_loc_1.host_container);
            if (Constants.USE_3D_OFFSET)
            {
                _loc_1.host_container.x = Constants.X_OFFSET_3D;
                _loc_1.host_container.y = Constants.Y_OFFSET_3D;
                var _loc_3:* = _loc_1.host_container.scaleY + Constants.SCALE_OFFSET_3D * 0.01;
                _loc_1.host_container.scaleY = _loc_1.host_container.scaleY + Constants.SCALE_OFFSET_3D * 0.01;
                _loc_1.host_container.scaleX = _loc_3;
            }
            var _loc_2:* = _loc_1.host_container.getAPI();
            _loc_2.allowRender(false, true);
            _loc_2.addEventListener(EngineEvent.CONFIG_DONE, e_configDone_3d);
            _loc_2.addEventListener(EngineEvent.TALK_ENDED, e_talkEnded);
            _loc_2.addEventListener(EngineEvent.TALK_STARTED, e_talkStarted);
            _loc_2.addEventListener(EngineEvent.MODEL_LOAD_ERROR, e_modelLoadError);
            _loc_2.addEventListener(EngineEvent.AUDIO_ERROR, e_audioError);
            return;
        }// end function

        private function loadHost2d() : void
        {
            var _loc_1:* = loading_host_data;
            _loc_1.host_container = new MovieClip();
            _loc_1.host_container.name = "container_" + _loc_1.id.toString();
            MovieClip(_loc_1.engine.display_obj).loadModel(_loc_1.url, _loc_1.host_container);
            return;
        }// end function

        private function dispatchAudioProgress(param1:Number) : void
        {
            var $percent:* = param1;
            dispatchEvent(new VHSSEvent(VHSSEvent.AUDIO_PROGRESS, {percent:int($percent * 100)}));
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_audioProgress", int($percent * 100));
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function deactivateLastHost() : void
        {
            if (active_host_data.host_container != null)
            {
                freeze();
                removeChild(active_host_data.host_container);
            }
            return;
        }// end function

        public function getActiveEngineAPI() : Object
        {
            return active_engine_api;
        }// end function

        public function sayAudio(param1:String, param2:Number = 0) : void
        {
            active_engine_api.say(param1, param2);
            return;
        }// end function

        public function saySilent(param1:Number) : void
        {
            active_engine_api.saySilent(param1);
            return;
        }// end function

        public function freeze() : void
        {
            active_engine_api.freeze();
            is_frozen = true;
            return;
        }// end function

        public function resume() : void
        {
            active_engine_api.resume();
            is_frozen = false;
            return;
        }// end function

        public function stopSpeech() : void
        {
            if (active_engine_api)
            {
                active_engine_api.stopSpeech();
            }
            return;
        }// end function

        public function sayMultiple(param1:Array) : void
        {
            active_engine_api.sayMultiple(param1);
            return;
        }// end function

        public function setPhoneme(param1:String) : void
        {
            active_engine_api.setPhoneme(param1);
            return;
        }// end function

        public function setFacialExpById(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
        {
            var _loc_6:String = null;
            var _loc_7:Number = NaN;
            if (active_host_data.type == HostStruct.HOST_3D)
            {
                active_engine_api.clearExpressionList();
                if (param1 > 0)
                {
                    _loc_6 = ExpressionMap.exp_ar[param1];
                    if (_loc_6 != null && _loc_6.length > 0)
                    {
                        _loc_7 = param2 == -1 ? (1000) : (param2);
                        if (param4 == 0)
                        {
                            param4 = Math.min(Constants.EXP_AD_MAX, Math.floor(_loc_7 * Constants.EXP_AD_PERCENT));
                        }
                        if (param5 == 0)
                        {
                            param5 = Math.min(Constants.EXP_AD_MAX, Math.floor(_loc_7 * Constants.EXP_AD_PERCENT));
                        }
                        active_engine_api.setExpression(_loc_6, param3, -1, param2, param4, param5);
                    }
                }
            }
            return;
        }// end function

        public function setFacialExpByString(param1:String, param2:Number, param3:Number = 1, param4:Number = 0, param5:Number = 0) : void
        {
            var _loc_6:Number = NaN;
            if (active_host_data.type == HostStruct.HOST_3D)
            {
                active_engine_api.clearExpressionList();
                _loc_6 = param2 == -1 ? (1000) : (param2);
                if (param4 == 0)
                {
                    param4 = Math.min(Constants.EXP_AD_MAX, Math.floor(_loc_6 * Constants.EXP_AD_PERCENT));
                }
                if (param5 == 0)
                {
                    param5 = Math.min(Constants.EXP_AD_MAX, Math.floor(_loc_6 * Constants.EXP_AD_PERCENT));
                }
                active_engine_api.setExpression(param1, param3, -1, param2, param4, param5);
            }
            return;
        }// end function

        public function followCursor(param1:Number) : void
        {
            if (active_engine_api)
            {
                active_engine_api.followCursor(param1);
            }
            return;
        }// end function

        public function recenter() : void
        {
            if (active_engine_api)
            {
                active_engine_api.recenter();
            }
            return;
        }// end function

        public function setGaze(param1:Number, param2:Number, param3:Number) : void
        {
            if (param1 == 0)
            {
                param1 = 360;
            }
            if (active_engine_api)
            {
                active_engine_api.setGaze(param1, param2, param3);
            }
            return;
        }// end function

        public function setColor(param1:String, param2:uint) : void
        {
            if (active_engine_api)
            {
                active_engine_api.setColor(param1, param2);
            }
            return;
        }// end function

        public function setLookSpeed(param1:String) : void
        {
            if (active_engine_api)
            {
                active_engine_api.setLookSpeed(param1);
            }
            return;
        }// end function

        public function setRandomMovement(param1:String) : void
        {
            if (active_engine_api)
            {
                active_engine_api.randomMovement(param1 != "0");
            }
            return;
        }// end function

        public function setRandomMovementParameters(param1:Number, param2:Number) : void
        {
            var frequency:* = param1;
            var radius:* = param2;
            try
            {
                active_engine_api.setRandomMovementParameters(frequency, radius);
            }
            catch (error)
            {
            }
            return;
        }// end function

        public function setSpeechMovement(param1:Number) : void
        {
            var amp:* = param1;
            try
            {
                active_engine_api.setEditValue(API_Constant.ADVANCED, EditLabel.F_SPEECH_HEADMOVE_AMPLITUDE, amp, 0);
            }
            catch (error)
            {
            }
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            var value:* = param1;
            try
            {
                if (active_host_data.type == HostStruct.HOST_3D)
                {
                    value = value * Constants.VOLUME_RANGE_3D.max;
                }
                else if (active_host_data.type == HostStruct.HOST_2D)
                {
                    value = value * Constants.VOLUME_RANGE_2D.max;
                }
                active_engine_api.setHostVolume(value);
            }
            catch (error)
            {
            }
            return;
        }// end function

        public function getIsFrozen() : Boolean
        {
            return is_frozen;
        }// end function

        override public function displayAsset(param1:LoadedAssetStruct) : void
        {
            if (!param1)
            {
                return;
            }
            deactivateLastHost();
            active_host_data = HostStruct(param1);
            active_engine_api = getEngineAPI(active_host_data);
            addChild(active_host_data.host_container);
            if (active_host_data.type == HostStruct.HOST_3D)
            {
                active_engine_api.allowRender(true, true);
            }
            else
            {
                active_engine_api.setActiveModel(active_host_data.model_ptr);
            }
            resume();
            return;
        }// end function

        override public function loadAsset(param1:LoadedAssetStruct) : void
        {
            var _loc_4:HostStruct = null;
            loading_host_data = HostStruct(param1);
            var _loc_2:* = HostStruct(param1);
            var _loc_3:* = escape(_loc_2.id.toString() + _loc_2.url);
            if (active_host_data == null || engine_holder.getLoadedAsset(_loc_2.engine.id.toString() + _loc_2.engine.url) == null)
            {
                stack[_loc_3] = _loc_2;
                engine_holder.loadAsset(_loc_2.engine);
            }
            else if (stack[_loc_3] != null)
            {
                _loc_4 = stack[_loc_3];
                loading_host_data.display_obj = _loc_4.display_obj;
                loading_host_data.model_ptr = _loc_4.model_ptr;
                loading_host_data.host_container = _loc_4.host_container;
                loading_host_data.loader = _loc_4.loader;
                dispatchEvent(new AssetEvent(AssetEvent.ASSET_INIT, loading_host_data));
                dispatchEvent(new VHSSEvent(VHSSEvent.CONFIG_DONE, loading_host_data));
            }
            else
            {
                loading_host_data.engine = EngineStruct(engine_holder.getLoadedAsset(_loc_2.engine.id.toString() + _loc_2.engine.url));
                stack[_loc_3] = _loc_2;
                if (_loc_2.type == HostStruct.HOST_3D)
                {
                    loadHost3d();
                }
                else
                {
                    loadHost2d();
                }
            }
            return;
        }// end function

        public function setProgressInterval(param1:Number) : void
        {
            var $progressInterval:* = param1;
            var _n:* = Math.floor($progressInterval);
            if (_n > 0 && timer_audio_progress == null)
            {
                timer_audio_progress = new Timer(_n * 1000);
                timer_audio_progress.addEventListener(TimerEvent.TIMER, e_audioProgressInterval);
            }
            else if (_n < 1)
            {
                try
                {
                    timer_audio_progress.stop();
                    timer_audio_progress.removeEventListener(TimerEvent.TIMER, e_audioProgressInterval);
                    timer_audio_progress = null;
                }
                catch (err:Error)
                {
                }
            }
            return;
        }// end function

        private function e_audioProgressInterval(event:TimerEvent) : void
        {
            var _loc_2:* = active_engine_api.getCurrentAudioProgress();
            dispatchAudioProgress(_loc_2);
            return;
        }// end function

        private function e_audioProgressComplete(event:TimerEvent) : void
        {
            return;
        }// end function

        private function e_engineLoaded(event:AssetEvent) : void
        {
            engineReady();
            return;
        }// end function

        private function e_audioEnded(param1) : void
        {
            var $ev:* = param1;
            dispatchEvent(new VHSSEvent(VHSSEvent.AUDIO_ENDED));
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_audioEnded");
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function e_audioStarted(param1) : void
        {
            var vhss_event:VHSSEvent;
            var $ev:* = param1;
            vhss_event = new VHSSEvent(VHSSEvent.AUDIO_STARTED);
            try
            {
                vhss_event.data = {sound_channel:active_engine_api.getEngineSoundChannel(), sound:active_engine_api.getEngineSound()};
            }
            catch (error:Error)
            {
                vhss_event.data = {sound_channel:new SoundChannel(), sound:new Sound()};
            }
            dispatchEvent(vhss_event);
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_audioStarted");
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function e_audioError(param1) : void
        {
            var t_ar:Array;
            var i:int;
            var $ev:* = param1;
            var t_error_loader:* = new ErrorReportingLoader();
            var t_str:String;
            try
            {
                t_str = $ev.data as String;
                t_ar = t_str.split(" ");
                i;
                while (i < t_ar.length)
                {
                    
                    if (String(t_ar[i]).indexOf(".mp3") != -1)
                    {
                        t_str = String(t_ar[i]);
                        break;
                    }
                    i = (i + 1);
                }
            }
            catch (error:Error)
            {
            }
            t_error_loader.report("audio_error", t_str);
            dispatchEvent(new VHSSEvent(VHSSEvent.AUDIO_ERROR));
            return;
        }// end function

        private function e_modelLoadError(param1) : void
        {
            var _loc_2:* = new ErrorReportingLoader();
            _loc_2.report("model_load_error");
            dispatchEvent(new VHSSEvent(VHSSEvent.MODEL_LOAD_ERROR));
            return;
        }// end function

        private function e_accessoryLoadError(event:EngineEvent) : void
        {
            var $ev:* = event;
            try
            {
                dispatchEvent(new VHSSEvent(VHSSEvent.ACCESSORY_LOAD_ERROR));
            }
            catch ($e)
            {
            }
            return;
        }// end function

        private function e_talkEnded(param1) : void
        {
            var $ev:* = param1;
            if (timer_audio_progress != null)
            {
                timer_audio_progress.stop();
                dispatchAudioProgress(1);
            }
            dispatchEvent(new VHSSEvent(VHSSEvent.TALK_ENDED));
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_talkEnded");
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function e_talkStarted(param1) : void
        {
            var $ev:* = param1;
            is_frozen = false;
            if (timer_audio_progress != null)
            {
                timer_audio_progress.start();
            }
            var _vhss_event:* = new VHSSEvent(VHSSEvent.TALK_STARTED);
            try
            {
                _vhss_event.data = $ev.data;
            }
            catch (error:Error)
            {
            }
            dispatchEvent(_vhss_event);
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.call("VHSS_Command", "vh_talkStarted");
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function e_configDone_2d(param1) : void
        {
            var $ev:* = param1;
            var t_hs:* = loading_host_data;
            t_hs.model_ptr = MovieClip($ev.data);
            var t_api:* = MovieClip(getEngineAPI(loading_host_data));
            if (t_hs.cs != null && t_hs.cs.length > 0)
            {
                t_api.configFromCS(t_hs.cs);
            }
            try
            {
                if (this.stage == null)
                {
                    t_api.setMouseStage(this.parent);
                }
                else
                {
                    t_api.setMouseStage(this.stage);
                }
            }
            catch (error:Error)
            {
            }
            dispatchEvent(new AssetEvent(AssetEvent.ASSET_INIT, loading_host_data));
            dispatchEvent(new VHSSEvent(VHSSEvent.CONFIG_DONE, loading_host_data));
            return;
        }// end function

        private function e_configDone_3d(param1) : void
        {
            var _loc_2:* = getEngineAPI(loading_host_data);
            _loc_2.addEventListener(EngineEventStrings.PROCESSING_STARTED, e_processingStarted);
            _loc_2.addEventListener(EngineEventStrings.PROCESSING_ENDED, e_processingEnded);
            _loc_2.loadURL(loading_host_data.url, EditLabel.U_HEAD, API_Constant.UNDO_FLAGS_NONE);
            return;
        }// end function

        private function e_processingStarted(param1) : void
        {
            return;
        }// end function

        private function e_processingEnded(param1) : void
        {
            var _loc_2:* = getEngineAPI(loading_host_data);
            _loc_2.setFaceMoveRange(move_range_3d);
            dispatchEvent(new AssetEvent(AssetEvent.ASSET_INIT, loading_host_data));
            dispatchEvent(new VHSSEvent(VHSSEvent.CONFIG_DONE, loading_host_data));
            return;
        }// end function

        override public function destroy() : void
        {
            var _loc_1:Object = null;
            var _loc_2:HostStruct = null;
            var _loc_3:Object = null;
            var _loc_4:MovieClip = null;
            var _loc_5:LoaderInfo = null;
            if (stack)
            {
                for each (_loc_1 in stack)
                {
                    
                    if (_loc_1 != null && _loc_1 is HostStruct)
                    {
                        _loc_2 = HostStruct(_loc_1);
                        if (_loc_2.type == HostStruct.HOST_2D)
                        {
                            _loc_3 = getEngineAPI(_loc_2);
                            if (_loc_3 != null)
                            {
                                _loc_4 = MovieClip(_loc_3);
                                _loc_4.removeEventListener(EngineEvent.CONFIG_DONE, e_configDone_2d);
                                _loc_4.removeEventListener(EngineEvent.TALK_ENDED, e_talkEnded);
                                _loc_4.removeEventListener(EngineEvent.TALK_STARTED, e_talkStarted);
                                _loc_4.removeEventListener(EngineEvent.AUDIO_ENDED, e_audioEnded);
                                _loc_4.removeEventListener(EngineEvent.AUDIO_STARTED, e_audioStarted);
                                _loc_4.removeEventListener(EngineEvent.AUDIO_ERROR, e_audioError);
                                _loc_4.removeEventListener(EngineEvent.MODEL_LOAD_ERROR, e_modelLoadError);
                            }
                        }
                        else if (_loc_2.type == HostStruct.HOST_3D)
                        {
                            _loc_3 = getEngineAPI(_loc_2);
                            if (_loc_3 != null)
                            {
                                _loc_3.removeEventListener(EngineEventStrings.PROCESSING_STARTED, e_processingStarted);
                                _loc_3.removeEventListener(EngineEventStrings.PROCESSING_ENDED, e_processingEnded);
                                _loc_3.removeEventListener(EngineEvent.CONFIG_DONE, e_configDone_3d);
                                _loc_3.removeEventListener(EngineEvent.TALK_ENDED, e_talkEnded);
                                _loc_3.removeEventListener(EngineEvent.TALK_STARTED, e_talkStarted);
                                _loc_3.removeEventListener(EngineEvent.AUDIO_ERROR, e_audioError);
                                _loc_3.removeEventListener(EngineEvent.MODEL_LOAD_ERROR, e_modelLoadError);
                            }
                        }
                        if (_loc_2.loader != null)
                        {
                            if (_loc_2.loader.contentLoaderInfo)
                            {
                                _loc_5 = _loc_2.loader.contentLoaderInfo;
                                _loc_5.removeEventListener(Event.INIT, e_initHandler);
                                _loc_5.removeEventListener(HTTPStatusEvent.HTTP_STATUS, e_httpStatusHandler);
                                _loc_5.removeEventListener(Event.COMPLETE, e_completeHandler);
                                _loc_5.removeEventListener(IOErrorEvent.IO_ERROR, e_ioErrorHandler);
                                _loc_5.removeEventListener(Event.OPEN, e_openHandler);
                                _loc_5.removeEventListener(ProgressEvent.PROGRESS, e_progressHandler);
                                _loc_5.removeEventListener(Event.UNLOAD, e_unLoadHandler);
                            }
                            _loc_2.loader.unload();
                            _loc_2.loader = null;
                        }
                        _loc_2.destroy();
                    }
                }
            }
            if (engine_holder != null)
            {
                engine_holder.removeEventListener(AssetEvent.ASSET_INIT, e_engineLoaded);
                engine_holder.destroy();
                engine_holder = null;
            }
            if (timer_audio_progress != null)
            {
                timer_audio_progress.stop();
                timer_audio_progress.removeEventListener(TimerEvent.TIMER, e_audioProgressInterval);
                timer_audio_progress = null;
            }
            active_host_data = null;
            loading_host_data = null;
            active_engine_api = null;
            Engine3d = null;
            while (this.numChildren > 0)
            {
                
                removeChildAt(0);
            }
            return;
        }// end function

    }
}
