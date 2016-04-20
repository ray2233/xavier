package com.oddcast.utils
{

    public class UTF8Encoder extends Object
    {

        public function UTF8Encoder()
        {
            return;
        }// end function

        public static function encode(param1:String) : String
        {
            var _loc_4:Number = NaN;
            var _loc_2:* = new String();
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_4 = param1.charCodeAt(_loc_3);
                if (_loc_4 < 128)
                {
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                }
                else if (_loc_4 > 127 && _loc_4 < 2048)
                {
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 | 192);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                }
                else
                {
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 12 | 224);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 & 63 | 128);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

    }
}
