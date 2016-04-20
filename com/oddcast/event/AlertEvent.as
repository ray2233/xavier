package com.oddcast.event
{
    import flash.events.*;

    public class AlertEvent extends TextEvent
    {
        public var code:String;
        public var moreInfo:Object;
        public var callback:Function;
        public var alertType:String;
        public var report_error:Boolean = true;
        public var block_user_feedback:Boolean = false;
        public static const EVENT:String = "error";
        public static const ALERT:String = "alert";
        public static const ERROR:String = "error";
        public static const CONFIRM:String = "confirm";

        public function AlertEvent(param1:String, param2:String, param3:String = "", param4:Object = null, param5:Function = null, param6:Boolean = true)
        {
            super(EVENT, true, false, param3);
            code = param2;
            moreInfo = param4;
            callback = param5;
            alertType = param1;
            report_error = param6;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AlertEvent(alertType, code, text, moreInfo, callback);
        }// end function

        override public function toString() : String
        {
            return formatToString("AlertEvent", "code", "moreInfo", "alertType");
        }// end function

    }
}
