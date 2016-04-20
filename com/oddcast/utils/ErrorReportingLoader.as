package com.oddcast.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class ErrorReportingLoader extends Loader
    {
        private var timeout_ref:int;
        private var prog_size:int;
        private var prog_timer:Timer;
        private var request_url:String;
        private static const TIMEOUT_TIME:int = 30000;
        private static const DATA_TIMEOUT:int = 1000;
        private static var REPORTED:Boolean = false;
        public static var ERROR_REPORTING_ACTIVE:Boolean = true;
        public static var REPORTING_URL:String = "http://track.oddcast.com/grabError.php";
        public static var PAGE_DOMAIN:String;

        public function ErrorReportingLoader()
        {
            return;
        }// end function

        override public function load(param1:URLRequest, param2:LoaderContext = null) : void
        {
            if (ERROR_REPORTING_ACTIVE && REPORTING_URL && !REPORTED)
            {
                timeout_ref = setTimeout(onTimeout, TIMEOUT_TIME);
                addListeners();
            }
            request_url = param1.url;
            super.load(param1, param2);
            return;
        }// end function

        public function report(param1:String = "", param2:String = "") : void
        {
            var req:URLRequest;
            var url_vars:URLVariables;
            var str:* = param1;
            var url:* = param2;
            if (ERROR_REPORTING_ACTIVE && REPORTING_URL && !REPORTED)
            {
                try
                {
                    req = new URLRequest(REPORTING_URL);
                    url_vars = new URLVariables();
                    url_vars.error = str.length > 0 ? ("ERL::" + str) : ("ERL::file_load_error");
                    if (request_url && request_url.length > 0)
                    {
                        url_vars.addInfo = request_url;
                    }
                    else if (url && url.length > 0)
                    {
                        url_vars.addInfo = url;
                    }
                    if (contentLoaderInfo && contentLoaderInfo.loaderURL)
                    {
                        url_vars.originator = contentLoaderInfo.loaderURL;
                    }
                    if (PAGE_DOMAIN && PAGE_DOMAIN.length > 0)
                    {
                        url_vars.appVer = PAGE_DOMAIN;
                    }
                    url_vars.browser = Capabilities.os + " " + Capabilities.version;
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
            this.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.contentLoaderInfo.addEventListener(Event.UNLOAD, onUnload);
            return;
        }// end function

        private function removeListeners() : void
        {
            clearTimeout(timeout_ref);
            if (prog_timer)
            {
                prog_timer.stop();
                prog_timer.removeEventListener(TimerEvent.TIMER, onProgTimer);
                prog_timer = null;
            }
            this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
            this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.contentLoaderInfo.removeEventListener(Event.UNLOAD, onUnload);
            return;
        }// end function

        private function onTimeout() : void
        {
            clearTimeout(timeout_ref);
            if (contentLoaderInfo && contentLoaderInfo.bytesLoaded)
            {
                prog_size = contentLoaderInfo.bytesLoaded;
                prog_timer = new Timer(1000);
                prog_timer.addEventListener(TimerEvent.TIMER, onProgTimer);
                prog_timer.start();
            }
            else
            {
                removeListeners();
                report();
            }
            return;
        }// end function

        private function onProgTimer(event:TimerEvent) : void
        {
            if (contentLoaderInfo.bytesLoaded - prog_size <= 1000)
            {
                removeListeners();
                report();
            }
            else
            {
                prog_size = contentLoaderInfo.bytesLoaded;
            }
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

        private function onUnload(event:Event) : void
        {
            removeListeners();
            return;
        }// end function

    }
}
