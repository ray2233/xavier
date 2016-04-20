package org.goasap.items
{
    import org.goasap.*;
    import org.goasap.interfaces.*;

    public class GoItem extends PlayableBase implements IUpdatable
    {
        public var useRounding:Boolean;
        public var useRelative:Boolean;
        protected var _pulse:int;
        public static var defaultPulseInterval:Number = -1;
        public static var defaultUseRounding:Boolean = false;
        public static var defaultUseRelative:Boolean = false;
        public static var timeMultiplier:Number = 1;

        public function GoItem()
        {
            useRounding = defaultUseRounding;
            useRelative = defaultUseRelative;
            _pulse = defaultPulseInterval;
            return;
        }// end function

        public function get pulseInterval() : int
        {
            return _pulse;
        }// end function

        public function set pulseInterval(param1:int) : void
        {
            if (_state == PlayStates.STOPPED && (param1 >= 0 || param1 == GoEngine.ENTER_FRAME))
            {
                _pulse = param1;
            }
            return;
        }// end function

        public function correctValue(param1:Number) : Number
        {
            if (isNaN(param1))
            {
                return 0;
            }
            if (useRounding)
            {
                var _loc_2:* = param1 % 1 == 0 ? (param1) : (param1 % 1 >= 0.5 ? ((int(param1) + 1)) : (int(param1)));
                param1 = param1 % 1 == 0 ? (param1) : (param1 % 1 >= 0.5 ? ((int(param1) + 1)) : (int(param1)));
                return _loc_2;
            }
            return param1;
        }// end function

        public function update(param1:Number) : void
        {
            return;
        }// end function

    }
}
