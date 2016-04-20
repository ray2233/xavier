package org.goasap.managers
{

    public class LinearGoRepeater extends Repeater
    {
        protected var _reverseOnCycle:Boolean = false;
        protected var _easingOnCycle:Function;
        protected var _extraEasingParams:Array;

        public function LinearGoRepeater(param1:uint = 1, param2:Boolean = true, param3:Function = null, param4:Array = null)
        {
            super(param1);
            _reverseOnCycle = param2;
            _easingOnCycle = param3;
            _extraEasingParams = param4;
            return;
        }// end function

        public function get reverseOnCycle() : Boolean
        {
            return _reverseOnCycle;
        }// end function

        public function set reverseOnCycle(param1:Boolean) : void
        {
            if (unlocked())
            {
                _reverseOnCycle = param1;
            }
            return;
        }// end function

        public function get direction() : int
        {
            if (_reverseOnCycle && _currentCycle % 2 == 1)
            {
                return -1;
            }
            return 1;
        }// end function

        public function get easingOnCycle() : Function
        {
            return _easingOnCycle;
        }// end function

        public function set easingOnCycle(param1:Function) : void
        {
            if (unlocked())
            {
                _easingOnCycle = param1;
            }
            return;
        }// end function

        public function get extraEasingParams() : Array
        {
            return _extraEasingParams;
        }// end function

        public function set extraEasingParams(param1:Array) : void
        {
            if (unlocked())
            {
                _extraEasingParams = param1;
            }
            return;
        }// end function

        public function get currentCycleHasEasing() : Boolean
        {
            return _reverseOnCycle && _currentCycle % 2 == 1 && _easingOnCycle != null;
        }// end function

    }
}
