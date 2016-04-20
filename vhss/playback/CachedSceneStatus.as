package vhss.playback
{
    import com.oddcast.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import vhss.*;

    public class CachedSceneStatus extends EventDispatcher
    {
        private var ldr:ErrorReportingURLLoader;
        private var to_int:uint;
        public var doc:String;

        public function CachedSceneStatus(param1:String) : void
        {
            var t_id:String;
            var t_params:URLVariables;
            var t_req:URLRequest;
            var $doc:* = param1;
            try
            {
                doc = $doc;
                t_id = doc.split("ss=")[1];
                t_id = t_id.split("/")[0];
                ldr = new ErrorReportingURLLoader();
                t_params = new URLVariables();
                t_req = new URLRequest();
                t_req.url = Constants.SCENE_STATUS_PHP;
                t_params.sc = t_id;
                t_params.t = "vhss";
                t_params.r = int(Math.random() * 100000);
                t_req.data = t_params;
                t_req.method = URLRequestMethod.GET;
                ldr.addEventListener(Event.COMPLETE, e_requestComplete);
                ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, e_error);
                ldr.addEventListener(IOErrorEvent.IO_ERROR, e_error);
                ldr.load(t_req);
                to_int = setTimeout(timeout, 5000);
            }
            catch ($e:Error)
            {
                e_error();
            }
            return;
        }// end function

        public function destroy() : void
        {
            try
            {
                removeListeners();
                ldr = null;
                clearTimeout(to_int);
            }
            catch ($e:Error)
            {
            }
            return;
        }// end function

        private function e_requestComplete(event:Event) : void
        {
            var _loc_3:String = null;
            var _loc_4:Array = null;
            clearTimeout(to_int);
            var _loc_2:* = ErrorReportingURLLoader(event.target).data;
            _loc_2 = _loc_2.split("=")[1];
            if (_loc_2 != null && _loc_2.length > 1)
            {
                _loc_3 = doc.substring(0, doc.indexOf("://"));
                _loc_4 = doc.split(".");
                _loc_4[0] = _loc_3 + "://" + _loc_2;
                doc = _loc_4.join(".");
                doc = doc + ("?r=" + int(Math.random() * 1000000));
            }
            dispatchEvent(new Event(Event.COMPLETE));
            removeListeners();
            return;
        }// end function

        private function timeout() : void
        {
            e_error();
            return;
        }// end function

        private function e_error(event:Event = null) : void
        {
            clearTimeout(to_int);
            dispatchEvent(new Event(Event.COMPLETE));
            removeListeners();
            return;
        }// end function

        private function removeListeners() : void
        {
            ldr.removeEventListener(Event.COMPLETE, e_requestComplete);
            ldr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, e_error);
            ldr.removeEventListener(IOErrorEvent.IO_ERROR, e_error);
            return;
        }// end function

    }
}
