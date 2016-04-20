package vhss.api
{
    import flash.events.*;
    import flash.net.*;
    import vhss.api.requests.*;

    public class Requester extends EventDispatcher
    {
        private var _url_loader:URLLoader;

        public function Requester()
        {
            return;
        }// end function

        public function destroy() : void
        {
            clearLoader();
            return;
        }// end function

        private function clearLoader() : void
        {
            if (_url_loader != null)
            {
                _url_loader.removeEventListener(Event.COMPLETE, e_complete);
                _url_loader.removeEventListener(IOErrorEvent.IO_ERROR, e_error);
                _url_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, e_security);
                _url_loader = null;
            }
            return;
        }// end function

        public function load(param1:APIRequest) : void
        {
            clearLoader();
            _url_loader = new URLLoader();
            _url_loader.addEventListener(Event.COMPLETE, e_complete);
            _url_loader.addEventListener(IOErrorEvent.IO_ERROR, e_error);
            _url_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, e_security);
            var _loc_2:* = getURLRequest();
            _url_loader.load(_loc_2);
            return;
        }// end function

        protected function getURLRequest() : URLRequest
        {
            return new URLRequest();
        }// end function

        protected function e_complete(event:Event) : void
        {
            return;
        }// end function

        private function e_error(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function e_security(event:SecurityErrorEvent) : void
        {
            return;
        }// end function

    }
}
