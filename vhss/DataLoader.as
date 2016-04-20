package vhss
{
    import com.oddcast.utils.*;
    import flash.events.*;
    import flash.net.*;
    import vhss.events.*;

    public class DataLoader extends EventDispatcher
    {
        private var load_type:String;

        public function DataLoader()
        {
            return;
        }// end function

        public function load(param1:URLRequest, param2:String) : void
        {
            var $req:* = param1;
            var in_type:* = param2;
            load_type = in_type;
            var loader:* = new ErrorReportingURLLoader();
            configureListeners(loader);
            try
            {
                loader.load($req);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function configureListeners(param1:IEventDispatcher) : void
        {
            param1.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
            param1.addEventListener(Event.OPEN, openHandler, false, 0, true);
            param1.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
            param1.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
            param1.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_3:DataLoaderEvent = null;
            var _loc_2:* = URLLoader(event.target);
            if (load_type == "xml")
            {
                _loc_3 = new DataLoaderEvent(DataLoaderEvent.ON_DATA_READY, {xml:new XML(_loc_2.data)});
            }
            else
            {
                _loc_3 = new DataLoaderEvent(DataLoaderEvent.ON_DATA_READY, {data:_loc_2.data});
            }
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function openHandler(event:Event) : void
        {
            return;
        }// end function

        private function progressHandler(event:ProgressEvent) : void
        {
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

        private function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

    }
}
