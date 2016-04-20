package com.oddcast.utils
{
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class ErrorReportingURLLoader extends URLLoader
    {
        private var timeout_ref:int;
        private var prog_size:int;
        private var request_url:String;
        private static const TIMEOUT_TIME:int = 30000;
        private static const DATA_TIMEOUT:int = 1000;
        private static var REPORTED:Boolean = false;
        public static var ERROR_REPORTING_ACTIVE:Boolean = true;
        public static var REPORTING_URL:String = "http://track.oddcast.com/grabError.php";
        public static var PAGE_DOMAIN:String;
        public static var PLAYER_URL:String;

        public function ErrorReportingURLLoader(param1:URLRequest = null)
        {
            super(param1);
            return;
        }// end function

        override public function load(param1:URLRequest) : void
        {
            if (ERROR_REPORTING_ACTIVE && REPORTING_URL && !REPORTED)
            {
                timeout_ref = setTimeout(onTimeout, TIMEOUT_TIME);
                addListeners();
            }
            request_url = param1.url;
            super.load(param1);
            return;
        }// end function

        public function report(param1:String = "") : void
        {
            var req:URLRequest;
            var url_vars:URLVariables;
            var str:* = param1;
            if (ERROR_REPORTING_ACTIVE && REPORTING_URL && !REPORTED)
            {
                try
                {
                    req = new URLRequest(REPORTING_URL);
                    url_vars = new URLVariables();
                    url_vars.error = str.length > 0 ? ("ERL::" + str) : ("ERL::file_load_error");
                    url_vars.addInfo = request_url;
                    url_vars.browser = Capabilities.os + " " + Capabilities.version;
                    if (PAGE_DOMAIN && PAGE_DOMAIN.length > 0)
                    {
                        url_vars.appVer = PAGE_DOMAIN;
                    }
                    if (PLAYER_URL && PLAYER_URL.length > 0)
                    {
                        url_vars.originator = PLAYER_URL;
                    }
                    req.data = url_vars;
                    sendToURL(req);
                }
                catch (error:Error)
                {
                }
            }
            return;
        }// end function

        private function addListeners() : void
        {
            this.addEventListener(Event.COMPLETE, onComplete);
            this.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.addEventListener(Event.UNLOAD, onUnload);
            this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            return;
        }// end function

        private function removeListeners() : void
        {
            clearTimeout(timeout_ref);
            this.removeEventListener(Event.COMPLETE, onComplete);
            this.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.removeEventListener(Event.UNLOAD, onUnload);
            this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            return;
        }// end function

        private function onTimeout() : void
        {
            removeListeners();
            report();
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            removeListeners();
            return;
        }// end function

        private function onIOError(event:IOErrorEvent) : void
        {
            removeListeners();
            report("io_error");
            return;
        }// end function

        private function onSecurityError(event:SecurityErrorEvent) : void
        {
            removeListeners();
            report("security_error");
            return;
        }// end function

        private function onUnload(event:Event) : void
        {
            removeListeners();
            return;
        }// end function

    }
}
