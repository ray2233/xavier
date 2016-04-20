package com.oddcast.event
{
    import flash.events.*;

    public class SkinEvent extends Event
    {
        public var obj:Object;
        public static var PLAY:String = "play";
        public static var STOP:String = "stop";
        public static var PAUSE:String = "pause";
        public static var MUTE:String = "mute";
        public static var UNMUTE:String = "unmute";
        public static var PREV:String = "prev";
        public static var NEXT:String = "next";
        public static var VOLUME_CHANGE:String = "volumeChange";
        public static var SAY_AI:String = "sayAI";
        public static var SAY_FAQ:String = "sayFAQ";
        public static var SEND_LEAD:String = "sendLead";
        public static var LEAD_SUCCESS:String = "leadSuccess";
        public static var LEAD_ERROR:String = "leadError";

        public function SkinEvent(param1:String, param2:Object = null, param3:Boolean = false)
        {
            super(param1, param3);
            obj = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new SkinEvent(type, obj);
        }// end function

    }
}
