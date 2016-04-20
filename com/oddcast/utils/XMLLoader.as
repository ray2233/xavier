package com.oddcast.utils
{
    import com.oddcast.event.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class XMLLoader extends Object
    {
        public static var lastError:String;
        public static var lastData:String;
        public static var lastUrl:String;
        private static var lastAlertEvent:AlertEvent;
        private static var loaders:Array = new Array();
        public static var retries:uint = 1;

        public function XMLLoader()
        {
            return;
        }// end function

        public static function loadXML(param1:String, param2:Function, ... args) : void
        {
            load(param1, param2, null, XML, args);
            return;
        }// end function

        public static function destroy() : void
        {
            while (loaders.length > 0)
            {
                
                removeLoader(loaders[0]);
            }
            return;
        }// end function

        public static function loadVars(param1:String, param2:Function, ... args) : void
        {
            load(param1, param2, null, URLVariables, args);
            return;
        }// end function

        public static function loadFile(param1:String, param2:Function, ... args) : void
        {
            load(param1, param2, null, ByteArray, args);
            return;
        }// end function

        public static function sendXML(param1:String, param2:Function, param3:XML, ... args) : void
        {
            load(param1, param2, param3, XML, args);
            return;
        }// end function

        public static function sendVars(param1:String, param2:Function, param3:URLVariables, ... args) : void
        {
            load(param1, param2, param3, XML, args);
            return;
        }// end function

        public static function sendFile(param1:String, param2:Function, param3:ByteArray, ... args) : void
        {
            load(param1, param2, param3, XML, args);
            return;
        }// end function

        public static function sendAndLoad(param1:String, param2:Function, param3, param4:Class, ... args) : void
        {
            load(param1, param2, param3, param4, args);
            return;
        }// end function

        private static function load(param1:String, param2:Function, param3, param4:Class, param5:Array) : void
        {
            var url:* = param1;
            var callback:* = param2;
            var sendObj:* = param3;
            var receiveClass:* = param4;
            var args:* = param5;
            var loader:* = new FileLoaderInstance();
            loader.addEventListener(Event.COMPLETE, loadDone);
            loader.addEventListener(ErrorEvent.ERROR, function (event:ErrorEvent) : void
            {
                loadError(event);
                if (callback != null)
                {
                    callback(null);
                }
                return;
            }// end function
            );
            loader.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent) : void
            {
                if (callback != null)
                {
                    callback(null);
                }
                return;
            }// end function
            );
            loader.retries = retries;
            loaders.push(loader);
            loader.loadWithCallback(url, callback, sendObj, receiveClass, args);
            return;
        }// end function

        private static function loadDone(event:Event) : void
        {
            var _loc_2:* = event.target as FileLoaderInstance;
            removeLoader(_loc_2);
            lastError = null;
            lastAlertEvent = _loc_2.getAlertEvent();
            lastUrl = _loc_2.url;
            lastData = _loc_2.data;
            return;
        }// end function

        private static function loadError(event:ErrorEvent) : void
        {
            var _loc_2:* = event.target as FileLoaderInstance;
            removeLoader(_loc_2);
            lastError = event.text;
            lastUrl = _loc_2.url;
            lastData = null;
            lastAlertEvent = _loc_2.getAlertEvent();
            return;
        }// end function

        private static function removeLoader(param1:FileLoaderInstance) : void
        {
            param1.removeEventListener(Event.COMPLETE, loadDone);
            param1.removeEventListener(ErrorEvent.ERROR, loadError);
            var _loc_2:* = loaders.indexOf(param1);
            if (_loc_2 == -1)
            {
                return;
            }
            delete loaders[_loc_2];
            loaders.splice(_loc_2, 1);
            return;
        }// end function

        public static function checkForAlertEvent(param1:String = null, param2:String = null) : AlertEvent
        {
            if (param2 == null)
            {
                param2 = param1;
            }
            if (lastAlertEvent != null && lastAlertEvent.code == null)
            {
                if (lastData == null)
                {
                    lastAlertEvent.code = param1;
                }
                else
                {
                    lastAlertEvent.code = param2;
                }
            }
            return lastAlertEvent;
        }// end function

    }
}
