package com.oddcast.audio
{
    import com.oddcast.encryption.*;
    import com.oddcast.utils.*;

    public class CachedTTS extends Object
    {
        private static var request_domain:String;
        private static var server_folder:String = "/c_fs";

        public function CachedTTS()
        {
            return;
        }// end function

        public static function setDomain(param1:String) : void
        {
            if (param1.lastIndexOf("/") == (param1.length - 1))
            {
                param1 = param1.substr(0, (param1.length - 1));
            }
            request_domain = param1;
            return;
        }// end function

        public static function setServerFolder(param1:String) : void
        {
            if (param1.indexOf("/") != 0)
            {
                param1 = "/" + param1;
            }
            server_folder = param1;
            return;
        }// end function

        public static function getTTSURL(param1:String, param2:int, param3:int, param4:int, param5:String = "", param6:Number = NaN) : String
        {
            if (param1 == null || param2 == 0 || param3 == 0 || param4 == 0)
            {
                throw new Error("Invalid TTS parameters");
            }
            var _loc_7:* = "<engineID>" + param4 + "</engineID><voiceID>" + param2 + "</voiceID><langID>" + param3 + "</langID>";
            if (param5 != "" && !isNaN(param6) && param6 != 0)
            {
                _loc_7 = _loc_7 + ("<FX>" + param5.toLowerCase() + param6 + "</FX>");
            }
            _loc_7 = _loc_7 + "<ext>mp3</ext>";
            var _loc_8:* = new md5();
            var _loc_9:* = new md5().hash(_loc_7 + UTF8Encoder.encode(param1));
            var _loc_10:* = request_domain + server_folder + "/" + _loc_9 + ".mp3?engine=" + param4 + "&language=" + param3 + "&voice=" + param2 + "&text=" + as2Encode(param1) + "&useUTF8=1";
            if (param5 != "" && !isNaN(param6) && param6 != 0)
            {
                _loc_10 = _loc_10 + ("&fx_type=" + escape(param5.toLowerCase()) + "&fx_level=" + param6);
            }
            return _loc_10;
        }// end function

        private static function as2Encode(param1:String) : String
        {
            var _loc_2:* = encodeURIComponent(param1);
            _loc_2 = _loc_2.split("-").join("%2D");
            _loc_2 = _loc_2.split("_").join("%5F");
            _loc_2 = _loc_2.split(".").join("%2E");
            return _loc_2;
        }// end function

    }
}
