package com.oddcast.event
{
    import flash.events.*;

    public class VHSSEvent extends Event
    {
        public var data:Object;
        public static const AI_RESPONSE:String = "vh_aiResponse";
        public static const AUDIO_LOADED:String = "vh_audioLoaded";
        public static const AUDIO_PROGRESS:String = "vh_audioProgress";
        public static const AUDIO_ENDED:String = "vh_audioEnded";
        public static const AUDIO_STARTED:String = "vh_audioStarted";
        public static const SCENE_LOADED:String = "vh_sceneLoaded";
        public static const SCENE_PRELOADED:String = "vh_scenePreloaded";
        public static const TTS_LOADED:String = "vh_ttsLoaded";
        public static const TALK_ENDED:String = "vh_talkEnded";
        public static const TALK_STARTED:String = "vh_talkStarted";
        public static const CONFIG_DONE:String = "config_done";
        public static const SKIN_LOADED:String = "skin_loaded";
        public static const BG_LOADED:String = "bg_loaded";
        public static const ENGINE_LOADED:String = "engine_loaded";
        public static const PLAYER_XML_ERROR:String = "player_xml_error";
        public static const PLAYER_READY:String = "player_ready";
        public static const MODEL_LOAD_ERROR:String = "model_load_error";
        public static const SCENE_PLAYBACK_COMPLETE:String = "scene_playback_complete";
        public static const PLAYER_DATA_ERROR:String = "player_data_error";
        public static const AUDIO_ERROR:String = "audio_error";
        public static const ACCESSORY_LOAD_ERROR:String = "accessory_load_error";

        public function VHSSEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
            this.data = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new VHSSEvent(type, this.data, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("VHSSEvent", "data", "type", "bubbles", "cancelable");
        }// end function

    }
}
