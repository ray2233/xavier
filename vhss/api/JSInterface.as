package vhss.api
{
    import flash.events.*;
    import flash.external.*;

    public class JSInterface extends Object
    {
        private static var dispatcher:EventDispatcher;

        public function JSInterface()
        {
            return;
        }// end function

        public static function initJSAPI(param1) : void
        {
            var _vhss:* = param1;
            if (ExternalInterface.available)
            {
                try
                {
                    var sayAudioExported:* = function (param1:String, param2:String = "", param3:Number = 0) : void
            {
                _vhss.sayAudioExported(param1, param3);
                return;
            }// end function
            ;
                    var sayTextExported:* = function (param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:String = "") : void
            {
                _vhss.sayTextExported(param1, param2, param3, param4, param6, param7, param5);
                return;
            }// end function
            ;
                    ExternalInterface.addCallback("setStatus", _vhss.setStatus);
                    ExternalInterface.addCallback("setBackground", _vhss.setBackground);
                    ExternalInterface.addCallback("setColor", _vhss.setColor);
                    ExternalInterface.addCallback("setLink", _vhss.setLink);
                    ExternalInterface.addCallback("is3D", _vhss.is3D);
                    ExternalInterface.addCallback("followCursor", _vhss.followCursor);
                    ExternalInterface.addCallback("freezeToggle", _vhss.freezeToggle);
                    ExternalInterface.addCallback("recenter", _vhss.recenter);
                    ExternalInterface.addCallback("setFacialExpression", _vhss.setFacialExpression);
                    ExternalInterface.addCallback("setGaze", _vhss.setGaze);
                    ExternalInterface.addCallback("loadAudio", _vhss.loadAudio);
                    ExternalInterface.addCallback("loadText", _vhss.loadText);
                    ExternalInterface.addCallback("sayAudio", _vhss.sayAudio);
                    ExternalInterface.addCallback("sayAudioExported", sayAudioExported);
                    ExternalInterface.addCallback("sayText", _vhss.sayText);
                    ExternalInterface.addCallback("sayTextExported", sayTextExported);
                    ExternalInterface.addCallback("sayAIResponse", _vhss.sayAIResponse);
                    ExternalInterface.addCallback("setPlayerVolume", _vhss.setPlayerVolume);
                    ExternalInterface.addCallback("sayByUrl", _vhss.sayByUrl);
                    ExternalInterface.addCallback("saySilent", _vhss.saySilent);
                    ExternalInterface.addCallback("sayMultiple", _vhss.sayMultiple);
                    ExternalInterface.addCallback("setPhoneme", _vhss.setPhoneme);
                    ExternalInterface.addCallback("stopSpeech", _vhss.stopSpeech);
                    ExternalInterface.addCallback("replay", _vhss.replay);
                    ExternalInterface.addCallback("gotoNextScene", _vhss.gotoNextScene);
                    ExternalInterface.addCallback("gotoPrevScene", _vhss.gotoPrevScene);
                    ExternalInterface.addCallback("gotoScene", _vhss.gotoScene);
                    ExternalInterface.addCallback("loadScene", _vhss.loadScene);
                    ExternalInterface.addCallback("loadShow", _vhss.loadShow);
                    ExternalInterface.addCallback("setNextSceneIndex", _vhss.setNextSceneIndex);
                    ExternalInterface.addCallback("preloadNextScene", _vhss.preloadNextScene);
                    ExternalInterface.addCallback("preloadScene", _vhss.preloadScene);
                    ExternalInterface.addCallback("setIdleMovement", _vhss.setIdleMovement);
                    ExternalInterface.addCallback("setSpeechMovement", _vhss.setSpeechMovement);
                }
                catch (error:SecurityError)
                {
                    ;
                }
                catch (error:Error)
                {
                }
                ;
            }
            return;
        }// end function

    }
}
