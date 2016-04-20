package com.pagodaflash.data
{

    public class ObjectUtil extends Object
    {

        public function ObjectUtil()
        {
            return;
        }// end function

        public static function isPrimitiveType(param1) : Boolean
        {
            return param1 is uint || param1 is int || param1 is Number || param1 is Boolean || param1 is String;
        }// end function

        public static function setProps(param1:Array, param2:String, param3) : void
        {
            var _loc_4:int = 0;
            while (_loc_4 < param1.length)
            {
                
                param1[_loc_4][param2] = param3;
                _loc_4++;
            }
            return;
        }// end function

        public static function access(param1:Object, param2:String, param3:String = ".")
        {
            var object:* = param1;
            var propPath:* = param2;
            var delim:* = param3;
            var _:* = function (param1:Object, param2:Array)
            {
                var _loc_3:* = param2.shift() as String;
                return _loc_3 ? (_(param1[_loc_3], param2)) : (param1);
            }// end function
            ;
            var props:* = propPath.split(delim);
            return ObjectUtil._(object, props);
        }// end function

        public static function assign(param1:Object, param2:String, param3, param4:String = ".")
        {
            var object:* = param1;
            var propPath:* = param2;
            var value:* = param3;
            var delim:* = param4;
            var _:* = function (param1:Object, param2:Array)
            {
                var _loc_3:* = param2.shift() as String;
                if (param2.length > 0)
                {
                    return _(param1[_loc_3], param2);
                }
                param1[_loc_3] = value;
                return param1[_loc_3];
            }// end function
            ;
            var props:* = propPath.split(delim);
            return ObjectUtil._(object, props);
        }// end function

        public static function duplicate(param1:Object) : Object
        {
            var _loc_3:* = undefined;
            var _loc_2:Object = {};
            for (_loc_3 in param1)
            {
                
                _loc_2[_loc_3] = param1[_loc_3];
            }
            return _loc_2;
        }// end function

    }
}
