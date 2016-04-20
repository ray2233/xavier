package com.oddcast.utils
{
    import com.oddcast.event.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class FileLoaderInstance extends EventDispatcher
    {
        public var url:String;
        private var request:URLRequest;
        public var errorStr:String;
        public var callback:Function;
        private var receiveClass:Class;
        public var args:Array;
        public var retries:uint = 0;
        private var retriesLeft:uint = 0;
        private var loader:URLLoader;
        private var loadTimer:Timer;
        public var timeoutSeconds:Number = 120;

        public function FileLoaderInstance()
        {
            return;
        }// end function

        public function get data() : String
        {
            return loader.data;
        }// end function

        public function loadWithCallback(param1:String, param2:Function, param3, param4:Class, param5:Array) : void
        {
            var _loc_6:* = new URLRequest(param1);
            if (param3 != null)
            {
                _loc_6.method = URLRequestMethod.POST;
            }
            if (param3 is URLVariables)
            {
                _loc_6.data = param3;
            }
            else if (param3 is XML)
            {
                _loc_6.data = param3.toXMLString();
                _loc_6.contentType = "text/xml";
            }
            else if (param3 is String)
            {
                _loc_6.data = param3;
            }
            else if (param3 is ByteArray)
            {
                _loc_6.data = param3;
                _loc_6.contentType = "application/octet-stream";
            }
            load(_loc_6, param2, param4, param5);
            return;
        }// end function

        public function loadRequest(param1:URLRequest, param2:Class = null) : void
        {
            if (param2 == null)
            {
                param2 = String;
            }
            load(param1, null, param2, null);
            return;
        }// end function

        private function load(param1:URLRequest, param2:Function, param3:Class, param4:Array, param5:Boolean = false) : void
        {
            var $request:* = param1;
            var $callback:* = param2;
            var $receiveClass:* = param3;
            var $args:* = param4;
            var $retry:* = param5;
            request = $request;
            url = request.url;
            receiveClass = $receiveClass;
            callback = $callback;
            args = $args;
            errorStr = null;
            if (!$retry)
            {
                retriesLeft = retries;
            }
            stop_load_timer();
            start_load_timer();
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            if (receiveClass == URLVariables)
            {
                loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            }
            else if (receiveClass == ByteArray)
            {
                loader.dataFormat = URLLoaderDataFormat.BINARY;
            }
            else
            {
                loader.dataFormat = URLLoaderDataFormat.TEXT;
            }
            try
            {
                loader.load(request);
            }
            catch (e:Error)
            {
                onError(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));
            }
            return;
        }// end function

        private function start_load_timer() : void
        {
            loadTimer = new Timer(timeoutSeconds * 1000, 1);
            loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
            loadTimer.start();
            return;
        }// end function

        private function stop_load_timer() : void
        {
            if (loadTimer == null)
            {
                return;
            }
            loadTimer.stop();
            loadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timeOut);
            loadTimer = null;
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            var receiveObj:*;
            var evt:* = event;
            try
            {
                if (receiveClass == XML)
                {
                    receiveObj = new XML(loader.data);
                }
                else if (receiveClass == URLVariables)
                {
                    receiveObj = loader.data as URLVariables;
                }
                else if (receiveClass == ByteArray)
                {
                    receiveObj = loader.data as ByteArray;
                }
                else if (receiveClass == String)
                {
                    receiveObj = loader.data as String;
                }
                else
                {
                    receiveObj = loader.data;
                }
            }
            catch (e:Error)
            {
                onError(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message));
                return;
            }
            errorStr = null;
            loader.removeEventListener(Event.COMPLETE, onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            stop_load_timer();
            dispatchEvent(evt);
            if (callback != null)
            {
                callback.apply(null, [receiveObj].concat(args));
            }
            return;
        }// end function

        private function onError(event:ErrorEvent) : void
        {
            if (retriesLeft > 0)
            {
                var _loc_3:* = retriesLeft - 1;
                retriesLeft = _loc_3;
                load(request, callback, receiveClass, args, true);
                return;
            }
            errorStr = event.text;
            stop_load_timer();
            loader.removeEventListener(Event.COMPLETE, onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text));
            if (callback != null)
            {
                callback.apply(null, [null].concat(args));
            }
            return;
        }// end function

        private function timeOut(event:TimerEvent) : void
        {
            var evt:* = event;
            onError(new ErrorEvent(ErrorEvent.ERROR, false, false, "Loading has timed out.  Please check your connection."));
            try
            {
                loader.close();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onHTTPStatus(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        public function getAlertEvent() : AlertEvent
        {
            var evt:AlertEvent;
            var errorReason:String;
            var _xml:XML;
            if (data == null)
            {
                if (errorStr == null)
                {
                    errorReason;
                }
                else
                {
                    errorReason = errorStr;
                }
            }
            else if (data.length == 0)
            {
                errorReason;
            }
            else if (receiveClass == XML)
            {
                try
                {
                    _xml = new XML(data);
                }
                catch (e:Error)
                {
                    _xml;
                }
                if (_xml == null)
                {
                    errorReason;
                }
                else if (_xml.name() == null)
                {
                    evt = getAlertEventFromString(data);
                    if (evt == null)
                    {
                        errorReason;
                    }
                }
                else
                {
                    evt = getAlertEventFromXML(_xml);
                }
            }
            else if (receiveClass == String)
            {
                evt = getAlertEventFromString(data);
            }
            if (evt == null && errorReason != null)
            {
                evt = new AlertEvent(AlertEvent.ERROR, null, "Error loading " + url + " : " + errorReason, {url:url, details:errorReason});
            }
            return evt;
        }// end function

        private function getAlertEventFromString(param1:String) : AlertEvent
        {
            var _loc_4:String = null;
            if (param1 == null || param1.length == 0)
            {
                return null;
            }
            if (param1.indexOf("Error") != 0)
            {
                return null;
            }
            var _loc_2:* = param1.indexOf("[");
            var _loc_3:* = param1.indexOf("]", _loc_2);
            if (_loc_2 != -1 && _loc_3 != -1)
            {
                _loc_4 = param1.slice((_loc_2 + 1), _loc_3);
            }
            if (_loc_4 == null || _loc_4.length == 0)
            {
                return null;
            }
            return new AlertEvent(AlertEvent.ERROR, _loc_4, param1);
        }// end function

        private function getAlertEventFromXML(param1:XML) : AlertEvent
        {
            if (param1 == null || param1.name() == null)
            {
                return null;
            }
            if (param1.name().toString() == "APIERROR")
            {
                return new AlertEvent(AlertEvent.ERROR, param1.@CODE, unescape(param1.@ERRORSTR));
            }
            return null;
        }// end function

    }
}
