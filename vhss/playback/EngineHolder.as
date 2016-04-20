package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import flash.display.*;
    import flash.events.*;

    public class EngineHolder extends AssetHolder
    {

        public function EngineHolder()
        {
            return;
        }// end function

        override public function destroy() : void
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
                        if (_loc_2.loader.content)
                        {
                            MovieClip(_loc_2.loader.content).destroy();
                        }
                        _loc_2.loader.unload();
                        _loc_2.loader = null;
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

    }
}
