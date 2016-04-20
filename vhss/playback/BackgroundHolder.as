package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import vhss.*;

    public class BackgroundHolder extends AssetHolder
    {
        private var bg_ss_api:IBackgroundAPI;
        private var bg_lib_ldr:ErrorReportingLoader;
        private var bg_lib_ready:Boolean = false;
        private static const BG_LIB_URL:String = "VHSSBgLib.swf";
        private static var anim_frame_rate:int = 12;

        public function BackgroundHolder(param1:String = "bg") : void
        {
            super(param1);
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            if (bg_ss_api)
            {
                bg_ss_api.setVolume(param1);
            }
            return;
        }// end function

        override public function loadAsset(param1:LoadedAssetStruct) : void
        {
            var _loc_3:DisplayObject = null;
            var _loc_4:Object = null;
            var _loc_2:* = BackgroundStruct(param1);
            switch(_loc_2.type)
            {
                case "video":
                {
                    loading_asset_data = param1;
                    if (bg_lib_ready)
                    {
                        if (bg_lib_ldr.contentLoaderInfo.applicationDomain.hasDefinition("vhss.playback.BgVideoPlayer"))
                        {
                            _loc_4 = bg_lib_ldr.contentLoaderInfo.applicationDomain.getDefinition("vhss.playback.BgVideoPlayer") as Class;
                            _loc_3 = new _loc_4(_loc_2);
                            _loc_2.display_obj = _loc_3;
                            _loc_3.addEventListener(Event.INIT, e_completeHandler);
                            _loc_3.addEventListener(Event.COMPLETE, e_playbackComplete);
                        }
                        else
                        {
                            e_completeHandler(new Event("null"));
                        }
                    }
                    else
                    {
                        loadBgLib();
                    }
                    break;
                }
                case "slideshow":
                {
                    loading_asset_data = param1;
                    if (bg_lib_ready)
                    {
                        if (bg_lib_ldr.contentLoaderInfo.applicationDomain.hasDefinition("vhss.playback.BgSlideshowPlayer"))
                        {
                            _loc_4 = bg_lib_ldr.contentLoaderInfo.applicationDomain.getDefinition("vhss.playback.BgSlideshowPlayer") as Class;
                            _loc_3 = new _loc_4(param1.url);
                            _loc_2.display_obj = _loc_3;
                            _loc_3.addEventListener(Event.INIT, e_completeHandler);
                            _loc_3.addEventListener(Event.COMPLETE, e_playbackComplete);
                        }
                        else
                        {
                            e_completeHandler(new Event("null"));
                        }
                    }
                    else
                    {
                        loadBgLib();
                    }
                    break;
                }
                default:
                {
                    super.loadAsset(param1);
                    break;
                }
            }
            return;
        }// end function

        override public function displayAsset(param1:LoadedAssetStruct) : void
        {
            var _bmp:Bitmap;
            var $asset:* = param1;
            stop();
            super.displayAsset($asset);
            var t_bg_asset:* = BackgroundStruct(active_asset_data);
            bg_ss_api = null;
            if (t_bg_asset == null)
            {
                return;
            }
            switch(t_bg_asset.type)
            {
                case "photo":
                {
                    try
                    {
                        _bmp = Bitmap(t_bg_asset.display_obj);
                        _bmp.smoothing = true;
                    }
                    catch (error:Error)
                    {
                    }
                    break;
                }
                case "slideshow":
                {
                    bg_ss_api = IBackgroundAPI(t_bg_asset.display_obj);
                    break;
                }
                case "video":
                {
                    bg_ss_api = IBackgroundAPI(t_bg_asset.display_obj);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function play() : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.bgPlay();
            }
            return;
        }// end function

        public function resume() : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.bgResume();
            }
            return;
        }// end function

        public function replay() : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.bgReplay();
            }
            return;
        }// end function

        public function stop() : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.bgStop();
            }
            return;
        }// end function

        public function pause() : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.bgPause();
            }
            return;
        }// end function

        public function displayBgFrame(param1:Number = 0) : void
        {
            if (bg_ss_api != null)
            {
                bg_ss_api.displayBgFrame(param1);
            }
            return;
        }// end function

        public function getStatus() : String
        {
            return bg_ss_api != null ? (bg_ss_api.getStatus()) : ("");
        }// end function

        override public function destroy() : void
        {
            var _loc_1:Object = null;
            var _loc_2:BackgroundStruct = null;
            var _loc_3:LoaderInfo = null;
            for each (_loc_1 in stack)
            {
                
                if (_loc_1 != null && _loc_1 is BackgroundStruct)
                {
                    _loc_2 = BackgroundStruct(_loc_1);
                    if ((_loc_2.type == "slideshow" || _loc_2.type == "video") && _loc_2.display_obj)
                    {
                        IBackgroundAPI(_loc_2.display_obj).destroy();
                    }
                    if (_loc_2.loader)
                    {
                        if (_loc_2.loader.contentLoaderInfo)
                        {
                            _loc_3 = _loc_2.loader.contentLoaderInfo;
                            _loc_3.removeEventListener(Event.INIT, e_initHandler);
                            _loc_3.removeEventListener(HTTPStatusEvent.HTTP_STATUS, e_httpStatusHandler);
                            _loc_3.removeEventListener(Event.COMPLETE, e_completeHandler);
                            _loc_3.removeEventListener(IOErrorEvent.IO_ERROR, e_ioErrorHandler);
                            _loc_3.removeEventListener(Event.OPEN, e_openHandler);
                            _loc_3.removeEventListener(ProgressEvent.PROGRESS, e_progressHandler);
                            _loc_3.removeEventListener(Event.UNLOAD, e_unLoadHandler);
                        }
                        _loc_2.loader.unload();
                        _loc_2.loader = null;
                        _loc_2.display_obj = null;
                    }
                    _loc_2.destroy();
                }
            }
            while (this.numChildren > 0)
            {
                
                removeChildAt(0);
            }
            return;
        }// end function

        private function loadBgLib() : void
        {
            var _loc_1:String = null;
            if (!bg_lib_ldr)
            {
                bg_lib_ldr = new ErrorReportingLoader();
                bg_lib_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadLib);
                bg_lib_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadLib);
                _loc_1 = Constants.PLAYER_URL;
                _loc_1 = _loc_1.split("?")[0].split("\\").join("/");
                _loc_1 = _loc_1.substring(0, (_loc_1.lastIndexOf("/") + 1));
                bg_lib_ldr.load(new URLRequest(_loc_1 + BG_LIB_URL));
            }
            else
            {
                e_completeHandler(new Event("null"));
            }
            return;
        }// end function

        private function e_playbackComplete(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        private function onCompleteLoadLib(event:Event) : void
        {
            bg_lib_ready = true;
            loadAsset(loading_asset_data);
            return;
        }// end function

        private function onErrorLoadLib(event:Event) : void
        {
            e_completeHandler(new Event("null"));
            return;
        }// end function

    }
}
