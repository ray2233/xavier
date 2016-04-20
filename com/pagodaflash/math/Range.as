package com.pagodaflash.math
{

    public class Range extends Object
    {
        public var min:Number;
        public var max:Number;

        public function Range(param1:Number, param2:Number)
        {
            this.min = param1;
            this.max = param2;
            return;
        }// end function

        public function clamp(param1:Number) : Number
        {
            if (param1 < min)
            {
                return min;
            }
            if (param1 > max)
            {
                return max;
            }
            return param1;
        }// end function

    }
}
