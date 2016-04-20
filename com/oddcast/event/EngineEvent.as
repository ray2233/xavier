package com.oddcast.event
{
    import flash.events.*;

    public class EngineEvent extends Event
    {
        public var data:Object;
        public static const CONFIG_DONE:String = "configDone";
        public static const TALK_STARTED:String = "talkStarted";
        public static const TALK_ENDED:String = "talkEnded";
        public static const AUDIO_ENDED:String = "audioEnded";
        public static const AUDIO_STARTED:String = "audioStarted";
        public static const WORD_ENDED:String = "wordEnded";
        public static const AUDIO_DOWNLOAD_START:String = "audioDownloadEnded";
        public static const AUDIO_ERROR:String = "audioError";
        public static const NEW_AUDIO_SEQUENCE:String = "newSequence";
        public static const NEW_MOUTH_FRAME:String = "newMouthFrame";
        public static const SMILE:String = "smile";
        public static const AUDIO_TIMER_EVENT:String = "audioTimeEvent";
        public static const SAY_SILENT_ENDED:String = "saySilentEnded";
        public static const ACCESSORY_LOADED:String = "accessoryLoaded";
        public static const ACCESSORY_INCOMPATIBLE:String = "accessoryIncompatible";
        public static const PROCESSING_STARTED:String = "processingStarted";
        public static const PROCESSING_ENDED:String = "processingEnded";
        public static const MODEL_LOAD_ERROR:String = "modelLoadError";
        public static const ACCESSORY_LOAD_ERROR:String = "accessoryLoadError";

        public function EngineEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = true) : void
        {
            super(param1, param3, param4);
            this.data = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new EngineEvent(type, this.data, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("EngineEvent", "data", "type", "bubbles", "cancelable");
        }// end function

    }
}
