package vhss.events
{
    import flash.events.*;

    public class APIEvent extends Event
    {
        public var data:Object;
        public static const SAY_AUDIO_URL:String = "audio_url";
        public static const AUDIO_CACHED:String = "audio_cached";
        public static const AI_COMPLETE:String = "ai_complete";
        public static const BG_URL:String = "bg_url";
        public static const TTS_URL:String = "tts_url";

        public function APIEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
            data = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new APIEvent(type, data, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("APIEvent", "data", "type", "bubbles", "cancelable");
        }// end function

    }
}
