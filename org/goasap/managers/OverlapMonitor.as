package org.goasap.managers
{
    import flash.utils.*;
    import org.goasap.interfaces.*;

    public class OverlapMonitor extends Object implements IManager
    {
        protected var handlers:Dictionary;
        protected var counts:Dictionary;

        public function OverlapMonitor()
        {
            handlers = new Dictionary(false);
            counts = new Dictionary(false);
            return;
        }// end function

        public function reserve(param1:IManageable) : void
        {
            var _loc_4:Object = null;
            var _loc_5:Dictionary = null;
            var _loc_6:Object = null;
            var _loc_2:* = param1.getActiveTargets();
            var _loc_3:* = param1.getActiveProperties();
            if (!_loc_2 || !_loc_3 || _loc_2.length == 0 || _loc_3.length == 0)
            {
                return;
            }
            for each (_loc_4 in _loc_2)
            {
                
                if (handlers[_loc_4] == null)
                {
                    handlers[_loc_4] = new Dictionary(false);
                    handlers[_loc_4][param1] = true;
                    counts[_loc_4] = 1;
                    continue;
                }
                _loc_5 = handlers[_loc_4] as Dictionary;
                if (_loc_5[param1])
                {
                    continue;
                }
                _loc_5[param1] = true;
                var _loc_9:* = counts;
                var _loc_10:* = _loc_4;
                var _loc_11:* = counts[_loc_4] + 1;
                _loc_9[_loc_10] = _loc_11;
                for (_loc_6 in _loc_5)
                {
                    
                    if (_loc_6 != param1)
                    {
                        if ((_loc_6 as IManageable).isHandling(_loc_3))
                        {
                            (_loc_6 as IManageable).releaseHandling();
                        }
                    }
                }
            }
            return;
        }// end function

        public function release(param1:IManageable) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = param1.getActiveTargets();
            for each (_loc_3 in _loc_2)
            {
                
                if (handlers[_loc_3] && handlers[_loc_3][param1] != null)
                {
                    delete handlers[_loc_3][param1];
                    var _loc_6:* = counts;
                    var _loc_7:* = _loc_3;
                    var _loc_8:* = counts[_loc_3] - 1;
                    _loc_6[_loc_7] = _loc_8;
                    if (counts[_loc_3] == 0)
                    {
                        delete handlers[_loc_3];
                        delete counts[_loc_3];
                    }
                }
            }
            return;
        }// end function

    }
}
