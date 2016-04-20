package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import vhss.events.*;

    public class AssetHolder extends Sprite
    {
        protected var stack:Dictionary;
        protected var type:String;
        protected var active_asset_data:LoadedAssetStruct;
        protected var loading_asset_data:LoadedAssetStruct;

        public function AssetHolder(param1:String = "asset") : void
        {
            type = param1;
            stack = new Dictionary();
            return;
        }// end function

        public function displayAsset(param1:LoadedAssetStruct) : void
        {
            var $asset:* = param1;
            if ($asset == null || $asset.url == null)
            {
                removeActiveAsset();
                active_asset_data = null;
            }
            else if (active_asset_data == null || $asset.url != active_asset_data.url)
            {
                removeActiveAsset();
                active_asset_data = $asset;
                if (active_asset_data.display_obj != null)
                {
                    try
                    {
                        addChild(active_asset_data.display_obj);
                    }
                    catch (e:Error)
                    {
                    }
                }
            }
            return;
        }// end function

        public function loadAsset(param1:LoadedAssetStruct) : void
        {
            var _loc_2:String = null;
            var _loc_3:URLRequest = null;
            var _loc_4:ErrorReportingLoader = null;
            var _loc_5:LoaderContext = null;
            var _loc_6:LoaderInfo = null;
            if (param1.url != null)
            {
                _loc_2 = escape(param1.id.toString() + param1.url);
                if (stack[_loc_2] == null)
                {
                    loading_asset_data = param1;
                    stack[_loc_2] = param1;
                    _loc_3 = new URLRequest(param1.url);
                    _loc_4 = new ErrorReportingLoader();
                    _loc_5 = getLoaderContext(param1);
                    _loc_6 = LoaderInfo(this.loaderInfo);
                    configureListeners(_loc_4.contentLoaderInfo);
                    param1.loader = _loc_4;
                    _loc_4.load(_loc_3, _loc_5);
                }
                else
                {
                    loading_asset_data = stack[_loc_2];
                    param1.loader = loading_asset_data.loader;
                    param1.display_obj = loading_asset_data.display_obj;
                    e_completeHandler(new Event(Event.INIT));
                }
            }
            else
            {
                loading_asset_data = param1;
                e_completeHandler(new Event(Event.INIT));
            }
            return;
        }// end function

        public function getLoadedAsset(param1:String) : LoadedAssetStruct
        {
            var _loc_2:* = escape(param1);
            return stack[_loc_2];
        }// end function

        protected function getLoaderContext(param1:LoadedAssetStruct) : LoaderContext
        {
            var _loc_2:* = new LoaderContext();
            if (param1.url.indexOf(".swf") == -1)
            {
                _loc_2.checkPolicyFile = true;
            }
            return _loc_2;
        }// end function

        protected function removeActiveAsset() : void
        {
            try
            {
                removeChild(active_asset_data.display_obj);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        protected function setType(param1:String) : void
        {
            type = param1;
            return;
        }// end function

        protected function configureListeners(param1:IEventDispatcher) : void
        {
            param1.addEventListener(Event.INIT, e_initHandler);
            param1.addEventListener(HTTPStatusEvent.HTTP_STATUS, e_httpStatusHandler);
            param1.addEventListener(Event.COMPLETE, e_completeHandler);
            param1.addEventListener(IOErrorEvent.IO_ERROR, e_ioErrorHandler);
            param1.addEventListener(Event.OPEN, e_openHandler);
            param1.addEventListener(ProgressEvent.PROGRESS, e_progressHandler);
            param1.addEventListener(Event.UNLOAD, e_unLoadHandler);
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:Object = null;
            var _loc_2:LoadedAssetStruct = null;
            var _loc_3:LoaderInfo = null;
            for each (_loc_1 in stack)
            {
                
                if (_loc_1 != null && _loc_1 is LoadedAssetStruct)
                {
                    _loc_2 = LoadedAssetStruct(_loc_1);
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

        protected function e_initHandler(event:Event) : void
        {
            if (event.target is LoaderInfo)
            {
                loading_asset_data.display_obj = LoaderInfo(event.target).content;
            }
            return;
        }// end function

        protected function e_httpStatusHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        protected function e_completeHandler(event:Event) : void
        {
            dispatchEvent(new AssetEvent(AssetEvent.ASSET_INIT, loading_asset_data));
            return;
        }// end function

        protected function e_ioErrorHandler(event:IOErrorEvent) : void
        {
            e_completeHandler(new Event("null"));
            return;
        }// end function

        protected function e_openHandler(event:Event) : void
        {
            return;
        }// end function

        protected function e_progressHandler(event:ProgressEvent) : void
        {
            return;
        }// end function

        protected function e_unLoadHandler(event:Event) : void
        {
            return;
        }// end function

    }
}
