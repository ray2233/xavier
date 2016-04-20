package com.oddcast.reports
{
    import flash.display.*;
    import flash.net.*;

    public class MultiUrlEventTracker extends EventTracker
    {
        private var url_array:Array;

        public function MultiUrlEventTracker()
        {
            url_array = new Array();
            return;
        }// end function

        override public function init(param1:String, param2:Object, param3:LoaderInfo = null) : void
        {
            url_array.push(param1);
            super.init(param1, param2, param3);
            return;
        }// end function

        override protected function sendRequest(param1:String) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < url_array.length)
            {
                
                sendToURL(new URLRequest(url_array[_loc_2] + param1));
                _loc_2++;
            }
            return;
        }// end function

        public function addReportingUrl(param1:String) : void
        {
            url_array.push(param1);
            return;
        }// end function

    }
}
