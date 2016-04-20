package 
{
    import VHSSPlayerV5.*;
    import com.oddcast.assets.structures.*;
    import com.oddcast.audio.*;
    import com.oddcast.event.*;
    import com.oddcast.host.api.*;
    import com.oddcast.player.*;
    import com.oddcast.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;
    import vhss.*;
    import vhss.api.*;
    import vhss.api.requests.*;
    import vhss.dataHandler.*;
    import vhss.events.*;
    import vhss.playback.*;
    import vhss.structures.*;

    public class VHSSPlayerV5 extends MovieClip implements IInternalPlayerAPI
    {
        private var flash_vars:Object;
        private var vhss_stage:Stage;
        private var show:ShowController;
        private var tts_creator:CachedTTS;
        private var tts_cacher:CacheAudioQueue;
        private var load_xml_timer:Timer;
        private var context_menu:ContextMenu;
        private var cached_doc_req:CachedSceneStatus;
        private var output_tf:TextField;
        private var show_domain_error:Boolean = true;
        private static var allowed_domains:Array = new Array("vhss-c.oddcast.com", "vhss-a.oddcast.com", "vhss.oddcast.com", "www.oddcast.com", "vhost.oddcast.com", "vhost.staging.oddcast.com", "www2.staging.oddcast.com", "content.staging.oddcast.com", "l-char.dev.oddcast.com", "l-char.oddcast.com", "char.dev.oddcast.com", "char.oddcast.com", "vhss-vd.oddcast.com", "vhss-vs.oddcast.com");

        public function VHSSPlayerV5()
        {
            try
            {
                Security.allowDomain("*");
            }
            catch ($error)
            {
                traceTxt("VHSS V5 - ERROR - allowDomain restriction");
            }
            t_time = Constants.VHSS_PLAYER_DATE;
            if (this.loaderInfo == null || this.loaderInfo.url == null)
            {
                traceTxt("VHSS V5 --- " + t_time + " listener  url " + this.loaderInfo.url + " dev version");
                this.loaderInfo.addEventListener(Event.COMPLETE, init);
            }
            else
            {
                traceTxt("VHSS V5 --- " + t_time + " direct    url " + this.loaderInfo.url);
                init();
            }
            return;
        }// end function

        private function prog(event:ProgressEvent) : void
        {
            return;
        }// end function

        private function _loadConfig() : void
        {
            var configUrl:String;
            var configLoader:URLLoader;
            var onConfigComplete:Function;
            var onConfigError:Function;
            onConfigComplete = function (event:Event) : void
            {
                configLoader.removeEventListener(Event.COMPLETE, onConfigComplete);
                configLoader.removeEventListener(IOErrorEvent.IO_ERROR, onConfigError);
                configLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onConfigError);
                configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onConfigError);
                Constants.parseConfiguration(new XML(event.target.data));
                _continueInit();
                return;
            }// end function
            ;
            onConfigError = function (event:Event) : void
            {
                configLoader.removeEventListener(Event.COMPLETE, onConfigComplete);
                configLoader.removeEventListener(IOErrorEvent.IO_ERROR, onConfigError);
                configLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR, onConfigError);
                configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onConfigError);
                _continueInit();
                return;
            }// end function
            ;
            var _info:* = LoaderInfo(this.loaderInfo);
            if (_info.parameters.config)
            {
                configUrl = _info.parameters.config;
            }
            else
            {
                configUrl = Constants.buildConfigUrl(_info.url);
            }
            configLoader = new URLLoader();
            configLoader.addEventListener(Event.COMPLETE, onConfigComplete);
            configLoader.addEventListener(IOErrorEvent.IO_ERROR, onConfigError);
            configLoader.addEventListener(IOErrorEvent.NETWORK_ERROR, onConfigError);
            configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConfigError);
            configLoader.load(new URLRequest(configUrl));
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            var _loc_2:* = LoaderInfo(this.loaderInfo);
            _loc_2.removeEventListener(Event.INIT, init);
            _loadConfig();
            return;
        }// end function

        private function _continueInit() : void
        {
            var t_cm_i:ContextMenuItem;
            var _isAvailable:Boolean;
            var _t_pd:String;
            var _t_ar:Array;
            var _info:* = LoaderInfo(this.loaderInfo);
            Constants.PLAYER_CONTEXT = _info.url;
            try
            {
                context_menu = new ContextMenu();
                t_cm_i = new ContextMenuItem("VHSS player ver. " + Constants.VHSS_PLAYER_VERSION, true);
                context_menu.hideBuiltInItems();
                context_menu.customItems.push(t_cm_i);
                contextMenu = context_menu;
            }
            catch (error:Error)
            {
            }
            Constants.FLASH_PLAYER_VERSION = Capabilities.version.split(" ")[1];
            var t_versions:* = Capabilities.version.split(" ")[1].split(",");
            if (t_versions[0] == 9 && t_versions[2] < 115 && _info.url.indexOf("file") != 0 && _info.loaderURL.indexOf("file") != 0)
            {
                showUpdateMessage();
            }
            else
            {
                _isAvailable = ExternalInterface.available;
                if (_info.loaderURL != _info.url)
                {
                    if (_info.loaderURL.indexOf("app:/") == 0)
                    {
                        Constants.PAGE_DOMAIN = _info.loaderURL.split("/").join("");
                        Constants.TRACKING_EMBED_ID = "7";
                    }
                    else
                    {
                        _t_ar = _info.loaderURL.split("://");
                        Constants.PAGE_DOMAIN = _t_ar[(_t_ar.length - 1)].split("/")[0].split(":")[0];
                        Constants.TRACKING_EMBED_ID = "6";
                    }
                    setErrorReportingVars(_info.loaderURL);
                    traceTxt("VHSS V5 ---  page domain : " + Constants.PAGE_DOMAIN);
                }
                else if (_isAvailable)
                {
                    try
                    {
                        _t_pd = ExternalInterface.call("eval", "location.href");
                    }
                    catch ($err:Error)
                    {
                    }
                    if (_t_pd == null)
                    {
                        _t_pd;
                    }
                    _t_ar = _t_pd.split("://");
                    Constants.PAGE_DOMAIN = _t_ar[(_t_ar.length - 1)].split("/")[0].split(":")[0];
                    setErrorReportingVars(_t_pd);
                    JSInterface.initJSAPI(this);
                    traceTxt("VHSS v5 -- page domain : " + Constants.PAGE_DOMAIN);
                }
                vhss_stage = this.stage;
                flash_vars = _info.parameters;
                if (flash_vars["pageDomain"] != null)
                {
                    allowed_domains.push(flash_vars["pageDomain"]);
                }
                if (Constants.PAGE_DOMAIN != null)
                {
                    allowed_domains.push(Constants.PAGE_DOMAIN);
                }
                allowDomains(allowed_domains);
                if (flash_vars["emb"] != null)
                {
                    Constants.TRACKING_EMBED_ID = flash_vars["emb"];
                }
                if (flash_vars != null && flash_vars["doc"] != null)
                {
                    if (flash_vars["embedid"] != null)
                    {
                        Constants.EMBED_ID = flash_vars["embedid"];
                    }
                    if (_info.url.indexOf("oddcast.com/vhss") != -1)
                    {
                        cached_doc_req = new CachedSceneStatus(flash_vars["doc"]);
                        cached_doc_req.addEventListener(Event.COMPLETE, e_gotSceneStatus);
                    }
                    else
                    {
                        loadShowXML(flash_vars["doc"]);
                    }
                }
                else if (!Constants.SUPPRESS_EXPORT_XML)
                {
                    load_xml_timer = new Timer(200, 1);
                    load_xml_timer.addEventListener(TimerEvent.TIMER, loadLocalXML);
                    load_xml_timer.start();
                }
            }
            dispatchEvent(new VHSSEvent(VHSSEvent.PLAYER_READY));
            return;
        }// end function

        private function setErrorReportingVars(param1:String) : void
        {
            var loading_str:* = param1;
            try
            {
                ErrorReportingLoader.ERROR_REPORTING_ACTIVE = Constants.ERROR_REPORTING_ACTIVE;
                ErrorReportingURLLoader.ERROR_REPORTING_ACTIVE = Constants.ERROR_REPORTING_ACTIVE;
                if (Constants.ERROR_REPORTING_ACTIVE)
                {
                    ErrorReportingLoader.PAGE_DOMAIN = loading_str;
                    ErrorReportingURLLoader.PAGE_DOMAIN = loading_str;
                    ErrorReportingURLLoader.PLAYER_URL = LoaderInfo(this.loaderInfo).url;
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function loadLocalXML(event:TimerEvent = null) : void
        {
            load_xml_timer.stop();
            var _loc_2:* = loaderInfo.url;
            _loc_2 = _loc_2.split("\\").join("/");
            Constants.RELATIVE_URL = _loc_2.substring(0, (_loc_2.lastIndexOf("/") + 1));
            loadShowXML(Constants.RELATIVE_URL + Constants.EXPORT_XML);
            return;
        }// end function

        private function allowDomains(param1:Array) : void
        {
            var $in_ar:* = param1;
            var i:uint;
            while (i < $in_ar.length)
            {
                
                try
                {
                    Security.allowDomain($in_ar[i]);
                    Security.allowInsecureDomain($in_ar[i]);
                }
                catch ($error)
                {
                }
                i = (i + 1);
            }
            return;
        }// end function

        private function onShowXmlReady(param1:XML) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = XMLLoader.checkForAlertEvent();
            if (_loc_2 != null)
            {
                _loc_3 = "";
                if (_loc_2.moreInfo != null && _loc_2.moreInfo.details != null)
                {
                    _loc_3 = _loc_2.moreInfo.details;
                }
                traceTxt("VHSS V5 xml error -- " + _loc_3);
                dispatchEvent(new VHSSEvent(VHSSEvent.PLAYER_XML_ERROR));
            }
            else
            {
                setShowXML(param1);
                startShow();
            }
            return;
        }// end function

        protected function setShowListeners() : void
        {
            show.addEventListener(VHSSEvent.SCENE_LOADED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.TALK_ENDED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.TALK_STARTED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.CONFIG_DONE, e_dispatchEvent);
            show.addEventListener(VHSSEvent.AUDIO_LOADED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.BG_LOADED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.SKIN_LOADED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.ENGINE_LOADED, e_dispatchEvent);
            show.addEventListener(APIEvent.AI_COMPLETE, e_aiResponse);
            show.addEventListener(VHSSEvent.SCENE_PRELOADED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.AUDIO_ENDED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.AUDIO_STARTED, e_dispatchEvent);
            show.addEventListener(VHSSEvent.MODEL_LOAD_ERROR, e_dispatchEvent);
            show.addEventListener(VHSSEvent.AUDIO_ERROR, e_dispatchEvent);
            show.addEventListener(VHSSEvent.SCENE_PLAYBACK_COMPLETE, e_dispatchEvent);
            return;
        }// end function

        private function stopExpXMLTimer() : void
        {
            if (load_xml_timer != null)
            {
                load_xml_timer.stop();
                load_xml_timer.removeEventListener(TimerEvent.TIMER, loadLocalXML);
            }
            return;
        }// end function

        private function showUpdateMessage() : void
        {
            var _loc_1:* = new MovieClip();
            var _loc_2:* = new TextField();
            var _loc_3:* = new TextFormat();
            addChild(_loc_1);
            _loc_1.addChild(_loc_2);
            _loc_1.graphics.beginFill(16711935, 0);
            _loc_1.graphics.drawRect(0, 0, 400, 300);
            _loc_1.buttonMode = true;
            _loc_1.useHandCursor = true;
            _loc_1.mouseChildren = false;
            _loc_2.htmlText = "<b>Flash version 9.0.115 or greater is required to view this content\n\n<font color=\'#0000FF\'><u>Click here</u></font> to update to the latest version</b>";
            _loc_2.width = 160;
            _loc_2.height = 300;
            _loc_2.antiAliasType = AntiAliasType.ADVANCED;
            _loc_2.multiline = true;
            _loc_2.wordWrap = true;
            _loc_2.selectable = false;
            _loc_2.autoSize = TextFieldAutoSize.CENTER;
            _loc_2.x = 400 / 2 - _loc_2.width / 2;
            _loc_2.y = 300 / 2 - _loc_2.height / 2;
            _loc_3.align = "center";
            _loc_3.size = 16;
            _loc_2.setTextFormat(_loc_3);
            _loc_1.addEventListener(MouseEvent.CLICK, e_updateFlash);
            return;
        }// end function

        public function useDefaultXML(param1:Boolean) : void
        {
            if (!param1)
            {
                stopExpXMLTimer();
            }
            else
            {
                loadLocalXML();
            }
            return;
        }// end function

        public function loadShowXML(param1:String) : void
        {
            stopExpXMLTimer();
            XMLLoader.loadXML(param1, onShowXmlReady);
            return;
        }// end function

        public function loadHost(param1:HostStruct) : void
        {
            var _loc_2:* = new HostStruct(param1.url, param1.id, param1.type);
            if (param1.cs != null)
            {
                _loc_2.cs = param1.cs;
            }
            _loc_2.engine.url = param1.engine.url;
            _loc_2.engine.type = param1.engine.type;
            _loc_2.engine.id = param1.engine.id;
            show.loadHost(_loc_2, true);
            return;
        }// end function

        public function initBlankShow() : void
        {
            if (show == null)
            {
                show = new ShowController(new SlideShowStruct());
                startShow();
            }
            return;
        }// end function

        public function loadBackground(param1:BackgroundStruct) : void
        {
            if (param1 == null)
            {
                param1 = new BackgroundStruct();
            }
            show.loadBg(param1, true);
            return;
        }// end function

        public function loadBackgroundWithTransform(param1:BackgroundStruct, param2:Object) : void
        {
            if (!param1)
            {
                param1 = new BackgroundStruct();
            }
            show.loadBg(param1, true, param2);
            return;
        }// end function

        public function loadSkin(param1:SkinStruct) : void
        {
            if (param1 == null)
            {
                param1 = new SkinStruct();
            }
            show.loadSkinFromAPI(param1, true);
            return;
        }// end function

        public function setSkinConfig(param1:XML) : void
        {
            show.setSkinConfig(param1);
            return;
        }// end function

        public function getShowXML() : XML
        {
            return show.getShowXML();
        }// end function

        public function getAudioUrl() : String
        {
            return show.getAudioUrl();
        }// end function

        public function setHostPosition(param1:int, param2:int, param3:int) : void
        {
            show.setHostPosition(param1, param2, param3);
            return;
        }// end function

        public function getActiveEngineAPI() : Object
        {
            return show.getActiveEngineAPI();
        }// end function

        public function getHostHolder() : Sprite
        {
            return show.getHostHolder();
        }// end function

        public function getBGHolder() : Sprite
        {
            return show.getBGHolder();
        }// end function

        public function setSceneAudio(param1:AudioStruct) : void
        {
            show.setSceneAudio(param1);
            return;
        }// end function

        public function setPlayerInitFlags(param1:int) : void
        {
            var $i:* = param1;
            if ($i & PlayerInitFlags.IGNORE_PLAY_ON_LOAD)
            {
                Constants.SUPPRESS_PLAY_ON_LOAD = true;
            }
            if ($i & PlayerInitFlags.TRACKING_OFF)
            {
                Constants.SUPPRESS_TRACKING = true;
            }
            if ($i & PlayerInitFlags.SUPPRESS_PLAY_ON_CLICK)
            {
                Constants.SUPPRESS_PLAY_ON_CLICK = true;
            }
            if ($i & PlayerInitFlags.SUPPRESS_EXPORT_XML)
            {
                Constants.SUPPRESS_EXPORT_XML = true;
                stopExpXMLTimer();
            }
            if ($i & PlayerInitFlags.SUPPRESS_3D_OFFSET)
            {
                Constants.USE_3D_OFFSET = false;
            }
            if ($i & PlayerInitFlags.SUPPRESS_LINKS)
            {
                Constants.SUPPRESS_LINK = true;
            }
            try
            {
                if ($i & PlayerInitFlags.SUPPRESS_AUTO_ADV)
                {
                    Constants.SUPPRESS_AUTO_ADV = true;
                }
            }
            catch ($e)
            {
            }
            return;
        }// end function

        public function setShowXML(param1:XML) : void
        {
            var _loc_2:Loader = null;
            var _loc_3:PlayerXMLHandler = null;
            var _loc_4:SlideShowStruct = null;
            var _loc_5:Loader = null;
            if (param1.name().toString().toUpperCase() == "ERROR")
            {
                _loc_2 = new Loader();
                addChild(_loc_2);
                _loc_2.load(new URLRequest(param1.@URL));
                dispatchEvent(new VHSSEvent(VHSSEvent.PLAYER_DATA_ERROR, "VHSS PLAYER:: xml load error"));
            }
            else
            {
                _loc_3 = new PlayerXMLHandler(param1);
                if (_loc_3.getErrorFile() == null)
                {
                    _loc_4 = _loc_3.getShowData();
                    if (flash_vars == null || flash_vars["bgcolor"] == null)
                    {
                        show = new ShowController(_loc_4);
                    }
                    else
                    {
                        show = new ShowController(_loc_4, flash_vars["bgcolor"]);
                    }
                }
                else
                {
                    _loc_5 = new Loader();
                    addChild(_loc_5);
                    _loc_5.load(new URLRequest(_loc_3.getErrorFile()));
                    dispatchEvent(new VHSSEvent(VHSSEvent.PLAYER_DATA_ERROR, "VHSS PLAYER:: account error"));
                }
            }
            return;
        }// end function

        public function set3DSceneSize(param1:int, param2:int) : void
        {
            return;
        }// end function

        public function startShow() : void
        {
            if (show != null)
            {
                setShowListeners();
                addChild(show);
                show.init();
            }
            return;
        }// end function

        public function displayBgFrame(param1:Number = 0) : void
        {
            if (show != null)
            {
                show.displayBgFrame(param1);
            }
            return;
        }// end function

        public function followCursor(param1:Number) : void
        {
            show.followCursor(param1);
            return;
        }// end function

        public function freezeToggle() : void
        {
            show.freezeToggle();
            return;
        }// end function

        public function recenter() : void
        {
            show.getHostHolder().recenter();
            return;
        }// end function

        public function setExpression(param1:Number, param2:Number, param3:Number = 100, param4:Number = 0, param5:Number = 0) : void
        {
            setFacialExpression(param1, param2, param3, param4, param5);
            return;
        }// end function

        public function setFacialExpression(param1, param2:Number, param3:Number = 100, param4:Number = 0, param5:Number = 0) : void
        {
            if (param2 > 0)
            {
                param2 = param2 * 1000;
            }
            if (isNaN(param3) || param3 <= 0 || param3 > 100)
            {
                param3 = 100;
            }
            show.setFacialExpression(param1, param2, param3 / 100, param4 * 1000, param5 * 1000);
            return;
        }// end function

        public function setGaze(param1:Number, param2:Number, param3:Number = 100, param4:Number = 0) : void
        {
            if (param1 == 0)
            {
                param1 = 360;
            }
            if (show && param1 && param2)
            {
                show.setGaze(param1, param2, param3, param4);
            }
            return;
        }// end function

        public function setIdleMovement(param1:int = 50, param2:int = 50) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (show)
            {
                if (param1 == 0 || param2 == 0)
                {
                    show.setRandomMovement("0");
                }
                else
                {
                    show.setRandomMovement("1");
                }
                _loc_3 = Math.min(Math.max(0, param1), 100) * 0.01;
                _loc_4 = Math.min(Math.max(0, param2), 100) * 0.01;
                show.setRandomMovementParameters(_loc_3, _loc_4);
            }
            return;
        }// end function

        public function setSpeechMovement(param1:int = 50) : void
        {
            var _loc_2:* = Math.max(Math.min(param1, 100), 0) * 0.01;
            show.getActiveEngineAPI().setEditValue(API_Constant.ADVANCED, EditLabel.F_SPEECH_HEADMOVE_AMPLITUDE, _loc_2, 0);
            return;
        }// end function

        public function setStatus(param1:Number = 0, param2:Number = 0, param3:Number = -1, param4:Number = -1) : void
        {
            show.setInterrupt(param1);
            show.getHostHolder().setProgressInterval(param2);
            if (param2 > 0)
            {
                show.getHostHolder().addEventListener(VHSSEvent.AUDIO_PROGRESS, e_dispatchEvent);
            }
            else
            {
                show.getHostHolder().removeEventListener(VHSSEvent.AUDIO_PROGRESS, e_dispatchEvent);
            }
            if (param3 == 0 || param3 == 1 || param3 == 2)
            {
                show.setLookSpeed(param3.toString());
            }
            if (param4 == 0 || param4 == 1)
            {
                show.setRandomMovement(param4.toString());
            }
            return;
        }// end function

        public function setBackground(param1:String) : void
        {
            show.setBackground(new APIRequest(param1));
            return;
        }// end function

        public function setColor(param1:String, param2:String) : void
        {
            var _loc_3:Boolean = true;
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                if (isNaN(parseInt(param2.charAt(_loc_4), 16)))
                {
                    _loc_3 = false;
                    break;
                }
                _loc_4++;
            }
            if (_loc_3)
            {
                show.setColor(param1, parseInt(param2, 16));
            }
            return;
        }// end function

        public function setLink(param1:String, param2:String = "_blank") : void
        {
            var _loc_3:* = new LinkStruct();
            _loc_3.url = param1;
            _loc_3.target = param2;
            show.setLink(_loc_3);
            return;
        }// end function

        public function is3D() : Boolean
        {
            var t_api:Object;
            try
            {
                t_api = show.getActiveEngineAPI();
                return getQualifiedClassName(t_api) != "EngineV5";
            }
            catch (e:Error)
            {
                return false;
            }
            return false;
        }// end function

        public function loadAudio(param1:String) : void
        {
            show.sayByName(new APIAudioRequest(param1, 0, true));
            return;
        }// end function

        public function loadText(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void
        {
            var t_url:String;
            var t_req:APIAudioRequest;
            var $text:* = param1;
            var $voice:* = param2;
            var $lang:* = param3;
            var $engine:* = param4;
            var $fx_type:* = param5;
            var $fx_level:* = param6;
            var $origin:* = param7;
            if ($text.length > 0 && $voice.length > 0 && $lang.length > 0 && $engine.length > 0)
            {
                if (this.loaderInfo.url.indexOf("oddcast") != -1 && Constants.IS_ENABLED_DOMAIN)
                {
                    $text = unescape($text);
                    CachedTTS.setDomain(Constants.TTS_DOMAIN);
                    if (Constants.IS_FILTERED)
                    {
                        $text = show.filterTTS($text, $lang);
                    }
                    t_url = CachedTTS.getTTSURL($text, parseInt($voice), parseInt($lang), parseInt($engine), $fx_type, parseInt($fx_level));
                    if (tts_cacher == null)
                    {
                        tts_cacher = new CacheAudioQueue();
                    }
                    t_req = new APIAudioRequest($text, 0, true);
                    t_req.url = t_url;
                    tts_cacher.addEventListener(APIEvent.AUDIO_CACHED, e_ttsCached);
                    tts_cacher.load(t_req);
                }
                else
                {
                    if (show_domain_error)
                    {
                        show_domain_error = false;
                        try
                        {
                            ExternalInterface.call("vhssError", "The scene is embedded on a domain that is not enabled in your account.");
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    throw new Error("The scene is embedded on a domain that is not enabled in your account.");
                }
            }
            return;
        }// end function

        public function sayAudio(param1:String, param2:Number = 0) : void
        {
            if (isNaN(param2))
            {
                param2 = 0;
            }
            param2 = Math.max(param2, 0);
            show.sayByName(new APIAudioRequest(param1, param2));
            return;
        }// end function

        public function sayText(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void
        {
            var $text:* = param1;
            var $voice:* = param2;
            var $lang:* = param3;
            var $engine:* = param4;
            var $fx_type:* = param5;
            var $fx_level:* = param6;
            var $origin:* = param7;
            $text = decodeURI($text);
            if ($text.length > 0 && $voice.length > 0 && $lang.length > 0 && $engine.length > 0)
            {
                if (this.loaderInfo.url.indexOf("oddcast") != -1 && Constants.IS_ENABLED_DOMAIN)
                {
                    show.sayText(new APITTSRequest(unescape($text), $voice, $lang, $engine, $fx_type, $fx_level));
                }
                else
                {
                    if (show_domain_error)
                    {
                        show_domain_error = false;
                        try
                        {
                            ExternalInterface.call("vhssError", "The scene is embedded on a domain that is not enabled in your account.");
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    throw new Error("The scene is embedded on a domain that is not enabled in your account.");
                }
            }
            return;
        }// end function

        public function sayAIResponse(param1:String, param2:String, param3:String, param4:String, param5:String = "0", param6:String = "", param7:String = "", param8:String = "") : void
        {
            param1 = decodeURI(param1);
            if (param1.length > 0 && param2.length > 0 && param3.length > 0 && param4.length > 0)
            {
                if (this.loaderInfo.url.indexOf("oddcast") != -1 && Constants.IS_AI_ENABLED)
                {
                    show.sayAIResponse(new APIAIRequest(param1, param2, param3, param4, param5, param6, param7));
                }
            }
            return;
        }// end function

        public function setPlayerVolume(param1:Number) : void
        {
            param1 = Constants.VOLUME_RANGE_PLAYER.clamp(param1);
            show.setVolume(param1 / Constants.VOLUME_RANGE_PLAYER.max);
            return;
        }// end function

        public function sayTextExported(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void
        {
            var $text:* = param1;
            var $voice:* = param2;
            var $lang:* = param3;
            var $engine:* = param4;
            var $fx_type:* = param5;
            var $fx_level:* = param6;
            var $origin:* = param7;
            $text = decodeURI($text);
            if ($text.length > 0 && $voice.length > 0 && $lang.length > 0 && $engine.length > 0)
            {
                if (Constants.IS_ENABLED_DOMAIN)
                {
                    show.sayText(new APITTSRequest(unescape($text), $voice, $lang, $engine, $fx_type, $fx_level));
                }
                else
                {
                    if (show_domain_error)
                    {
                        show_domain_error = false;
                        try
                        {
                            ExternalInterface.call("vhssError", "The scene is embedded on a domain that is not enabled in your account.");
                        }
                        catch (error:Error)
                        {
                        }
                    }
                    throw new Error("The scene is embedded on a domain that is not enabled in your account.");
                }
            }
            return;
        }// end function

        public function sayAudioExported(param1:String, param2:Number = 0) : void
        {
            if (isNaN(param2))
            {
                param2 = 0;
            }
            show.sayByNameExported(new APIAudioRequest(param1, param2));
            return;
        }// end function

        public function sayByUrl(param1:String) : void
        {
            show.sayAudio(param1);
            return;
        }// end function

        public function sayMultiple(param1:Array) : void
        {
            show.sayMultiple(param1);
            return;
        }// end function

        public function saySilent(param1:Number) : void
        {
            show.getHostHolder().saySilent(param1);
            return;
        }// end function

        public function setPhoneme(param1:String) : void
        {
            show.getHostHolder().setPhoneme(param1);
            return;
        }// end function

        public function stopSpeech() : void
        {
            if (show)
            {
                show.stopSpeech();
            }
            return;
        }// end function

        public function replay(param1:Number = 0) : void
        {
            show.replay(param1 == 1);
            return;
        }// end function

        public function gotoPrevScene() : void
        {
            show.gotoPrevScene();
            return;
        }// end function

        public function gotoScene(param1:Object) : void
        {
            var _loc_2:Array = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            if (String(param1).indexOf("-") != -1)
            {
                _loc_2 = String(param1).split("-");
                _loc_3 = parseInt(_loc_2[0]);
                _loc_4 = parseInt(_loc_2[1]);
                _loc_5 = uint(Math.random() * (_loc_4 - _loc_3 + 1)) + _loc_3;
                show.gotoScene(_loc_5);
            }
            else
            {
                show.gotoScene(uint(param1));
            }
            return;
        }// end function

        public function gotoNextScene() : void
        {
            show.gotoNextScene();
            return;
        }// end function

        public function preloadNextScene() : void
        {
            show.preloadNextScene();
            return;
        }// end function

        public function preloadScene(param1:Number) : void
        {
            show.preloadScene(int((param1 - 1)));
            return;
        }// end function

        public function setNextSceneIndex(param1:Object) : void
        {
            var _loc_2:Array = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            if (String(param1).indexOf("-") != -1)
            {
                _loc_2 = String(param1).split("-");
                _loc_3 = parseInt(_loc_2[0]);
                _loc_4 = parseInt(_loc_2[1]);
                _loc_5 = uint(Math.random() * (_loc_4 - _loc_3 + 1)) + _loc_3;
                show.setNextSceneIndex(_loc_5);
            }
            else
            {
                show.setNextSceneIndex(uint(param1));
            }
            return;
        }// end function

        public function loadScene(param1:int) : void
        {
            if (flash_vars != null && flash_vars["doc"] != null)
            {
                show.destroy();
                loadShowXML(flash_vars["doc"] + "/ind=" + param1);
            }
            return;
        }// end function

        public function loadShow(param1:int) : void
        {
            loadScene(param1);
            return;
        }// end function

        private function e_gotSceneStatus(event:Event) : void
        {
            loadShowXML(cached_doc_req.doc);
            cached_doc_req.removeEventListener(Event.COMPLETE, e_gotSceneStatus);
            cached_doc_req = null;
            return;
        }// end function

        protected function e_dispatchEvent(event:VHSSEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function e_ttsCached(event:APIEvent) : void
        {
            var $e:* = event;
            try
            {
                ExternalInterface.call("VHSS_Command", "vh_ttsLoaded", APIAudioRequest($e.data).name);
            }
            catch ($e:Error)
            {
            }
            var t_ve:* = new VHSSEvent(VHSSEvent.TTS_LOADED);
            t_ve.data = APIAudioRequest($e.data).name;
            dispatchEvent(t_ve);
            return;
        }// end function

        protected function e_aiResponse(event:APIEvent) : void
        {
            var $e:* = event;
            var t_txt:* = AIResponse($e.data).display_text.length > 0 ? (escape(AIResponse($e.data).display_text)) : (escape(AIResponse($e.data).ai_request.name));
            var t_tag:* = AIResponse($e.data).display_tag;
            if (t_tag != null && t_tag.length > 0)
            {
                t_txt = t_txt + ("|" + t_tag);
            }
            try
            {
                ExternalInterface.call("VHSS_Command", "vh_aiResponse", t_txt);
            }
            catch ($e:Error)
            {
            }
            var t_ve:* = new VHSSEvent(VHSSEvent.AI_RESPONSE);
            t_ve.data = t_txt;
            dispatchEvent(t_ve);
            return;
        }// end function

        private function e_updateFlash(event:Event) : void
        {
            navigateToURL(new URLRequest("http://get.adobe.com/flashplayer/"), "_blank");
            return;
        }// end function

        public function destroy() : void
        {
            traceTxt("VHSS v5 -------- Destroy");
            this.loaderInfo.removeEventListener(Event.COMPLETE, init);
            if (load_xml_timer != null)
            {
                traceTxt("VHSS - destroy - load_xml_timer");
                load_xml_timer.removeEventListener(TimerEvent.TIMER, loadLocalXML);
            }
            if (tts_cacher != null)
            {
                traceTxt("VHSS - destroy - tts_cacher");
                tts_cacher.removeEventListener(APIEvent.AUDIO_CACHED, e_ttsCached);
            }
            if (cached_doc_req != null)
            {
                traceTxt("VHSS - destroy - cached_doc_req");
                cached_doc_req.removeEventListener(Event.COMPLETE, e_gotSceneStatus);
                cached_doc_req.destroy();
                cached_doc_req = null;
            }
            if (show != null)
            {
                traceTxt("VHSS - destroy - show");
                show.getHostHolder().removeEventListener(VHSSEvent.AUDIO_PROGRESS, e_dispatchEvent);
                show.destroy();
                show.removeEventListener(VHSSEvent.SCENE_LOADED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.TALK_ENDED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.TALK_STARTED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.CONFIG_DONE, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.AUDIO_LOADED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.BG_LOADED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.SKIN_LOADED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.ENGINE_LOADED, e_dispatchEvent);
                show.removeEventListener(APIEvent.AI_COMPLETE, e_aiResponse);
                show.removeEventListener(VHSSEvent.SCENE_PRELOADED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.AUDIO_ENDED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.AUDIO_STARTED, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.AUDIO_ERROR, e_dispatchEvent);
                show.removeEventListener(VHSSEvent.SCENE_PLAYBACK_COMPLETE, e_dispatchEvent);
                show = null;
                traceTxt("VHSS - destroy - show end");
            }
            XMLLoader.destroy();
            return;
        }// end function

        public function setTextOutput(param1:TextField) : void
        {
            output_tf = param1;
            return;
        }// end function

        private function traceTxt(param1:String) : void
        {
            if (output_tf)
            {
                output_tf.appendText("\t-" + param1 + "\n");
            }
            return;
        }// end function

    }
}
