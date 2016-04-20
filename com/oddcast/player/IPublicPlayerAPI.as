package com.oddcast.player
{
    import flash.events.*;

    public interface IPublicPlayerAPI extends IEventDispatcher
    {

        public function IPublicPlayerAPI();

        function followCursor(param1:Number) : void;

        function freezeToggle() : void;

        function recenter() : void;

        function setGaze(param1:Number, param2:Number, param3:Number = 100, param4:Number = 0) : void;

        function setFacialExpression(param1, param2:Number, param3:Number = 100, param4:Number = 0, param5:Number = 0) : void;

        function loadAudio(param1:String) : void;

        function loadText(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void;

        function sayAudio(param1:String, param2:Number = 0) : void;

        function sayText(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void;

        function sayAIResponse(param1:String, param2:String, param3:String, param4:String, param5:String = "0", param6:String = "", param7:String = "", param8:String = "") : void;

        function saySilent(param1:Number) : void;

        function setPlayerVolume(param1:Number) : void;

        function setStatus(param1:Number = 0, param2:Number = 0, param3:Number = -1, param4:Number = -1) : void;

        function stopSpeech() : void;

        function sayByUrl(param1:String) : void;

        function sayTextExported(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void;

        function sayAudioExported(param1:String, param2:Number = 0) : void;

        function setBackground(param1:String) : void;

        function setColor(param1:String, param2:String) : void;

        function setLink(param1:String, param2:String = "_blank") : void;

        function gotoNextScene() : void;

        function gotoPrevScene() : void;

        function gotoScene(param1:Object) : void;

        function loadShow(param1:int) : void;

        function preloadNextScene() : void;

        function preloadScene(param1:Number) : void;

        function replay(param1:Number = 0) : void;

        function setNextSceneIndex(param1:Object) : void;

    }
}
