package org.goasap.managers
{
    import org.goasap.*;

    public class Repeater extends Object
    {
        protected var _item:PlayableBase;
        protected var _cycles:uint;
        protected var _currentCycle:uint = 0;
        public static const INFINITE:uint = 0;

        public function Repeater(param1:uint = 1)
        {
            _cycles = param1;
            return;
        }// end function

        public function get cycles() : uint
        {
            return _cycles;
        }// end function

        public function set cycles(param1:uint) : void
        {
            if (unlocked())
            {
                _cycles = param1;
            }
            return;
        }// end function

        public function get currentCycle() : uint
        {
            return _currentCycle;
        }// end function

        public function get done() : Boolean
        {
            return _currentCycle == _cycles && _cycles != INFINITE;
        }// end function

        public function setParent(param1:PlayableBase) : void
        {
            if (!_item)
            {
                _item = param1;
            }
            return;
        }// end function

        public function next() : Boolean
        {
            if (_cycles == INFINITE)
            {
                var _loc_2:* = _currentCycle + 1;
                _currentCycle = _loc_2;
                return true;
            }
            if (_cycles - _currentCycle > 0)
            {
                var _loc_2:* = _currentCycle + 1;
                _currentCycle = _loc_2;
            }
            if (_cycles == _currentCycle)
            {
                return false;
            }
            return true;
        }// end function

        public function hasNext() : Boolean
        {
            return _cycles == INFINITE || _cycles - _currentCycle > 1;
        }// end function

        public function skipTo(param1:Number, param2:Number) : Number
        {
            if (isNaN(param1) || isNaN(param2))
            {
                return 0;
            }
            param2 = Math.max(0, param2);
            if (cycles != INFINITE)
            {
                param2 = Math.min(param2, _cycles * param1);
            }
            _currentCycle = Math.floor(param2 / param1);
            return param2 % param1;
        }// end function

        public function reset() : void
        {
            _currentCycle = 0;
            return;
        }// end function

        protected function unlocked() : Boolean
        {
            return !_item || _item && _item.state == PlayStates.STOPPED;
        }// end function

    }
}
