package org.goasap
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import org.goasap.interfaces.*;

    public class GoEngine extends Object
    {
        public static const INFO:String = "GoASAP 0.5.0 (c) Moses Gunesch, MIT Licensed.";
        public static const ENTER_FRAME:int = -1;
        private static var managerTable:Object = new Object();
        private static var managers:Array = new Array();
        private static var liveManagers:uint = 0;
        private static var timers:Dictionary = new Dictionary(false);
        private static var items:Dictionary = new Dictionary(false);
        private static var itemCounts:Dictionary = new Dictionary(false);
        private static var pulseSprite:Sprite;
        private static var paused:Boolean = false;
        private static var lockedPulses:Dictionary = new Dictionary(false);
        private static var delayedPulses:Dictionary = new Dictionary(false);
        private static var addQueue:Dictionary = new Dictionary(false);

        public function GoEngine()
        {
            return;
        }// end function

        public static function getManager(param1:String) : IManager
        {
            return managerTable[param1];
        }// end function

        public static function addManager(param1:IManager) : void
        {
            var _loc_2:* = getQualifiedClassName(param1);
            _loc_2 = _loc_2.slice(_loc_2.lastIndexOf("::") + 2);
            if (managerTable[_loc_2])
            {
                throw new DuplicateManagerError(_loc_2);
            }
            managerTable[_loc_2] = param1;
            managers.push(param1);
            if (param1 is ILiveManager)
            {
                var _loc_4:* = liveManagers + 1;
                liveManagers = _loc_4;
            }
            return;
        }// end function

        public static function removeManager(param1:String) : void
        {
            managers.splice(managers.indexOf(managerTable[param1]), 1);
            if (managerTable[param1] is ILiveManager)
            {
                var _loc_3:* = liveManagers - 1;
                liveManagers = _loc_3;
            }
            delete managerTable[param1];
            return;
        }// end function

        public static function hasItem(param1:IUpdatable) : Boolean
        {
            return items[param1] != null;
        }// end function

        public static function addItem(param1:IUpdatable) : Boolean
        {
            var _loc_3:IManager = null;
            var _loc_2:* = param1.pulseInterval;
            if (items[param1])
            {
                if (items[param1] == param1.pulseInterval)
                {
                    return false;
                }
                removeItem(param1);
            }
            if (lockedPulses[_loc_2] == true)
            {
                delayedPulses[_loc_2] = true;
                addQueue[param1] = true;
            }
            items[param1] = _loc_2;
            if (!timers[_loc_2])
            {
                addPulse(_loc_2);
                itemCounts[_loc_2] = 1;
            }
            else
            {
                var _loc_4:* = itemCounts;
                var _loc_5:* = _loc_2;
                var _loc_6:* = itemCounts[_loc_2] + 1;
                _loc_4[_loc_5] = _loc_6;
            }
            if (param1 is IManageable)
            {
                for each (_loc_3 in managers)
                {
                    
                    _loc_3.reserve(param1 as IManageable);
                }
            }
            return true;
        }// end function

        public static function removeItem(param1:IUpdatable) : Boolean
        {
            var _loc_3:IManager = null;
            if (items[param1] == null)
            {
                return false;
            }
            var _loc_2:* = items[param1];
            var _loc_4:* = itemCounts;
            var _loc_5:* = _loc_2;
            _loc_4[_loc_5] = itemCounts[_loc_2] - 1;
            if (--itemCounts[_loc_2] == 0)
            {
                removePulse(_loc_2);
                delete itemCounts[_loc_2];
            }
            delete items[param1];
            delete addQueue[param1];
            if (param1 is IManageable)
            {
                for each (_loc_3 in managers)
                {
                    
                    _loc_3.release(param1 as IManageable);
                }
            }
            return true;
        }// end function

        public static function clear(param1:Number = NaN) : uint
        {
            var _loc_4:Object = null;
            var _loc_2:* = isNaN(param1);
            var _loc_3:Number = 0;
            for (_loc_4 in items)
            {
                
                if (_loc_2 || items[_loc_4] == param1)
                {
                    if (removeItem(_loc_4 as IUpdatable) == true)
                    {
                        _loc_3 = _loc_3 + 1;
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function getCount(param1:Number = NaN) : uint
        {
            var _loc_3:int = 0;
            if (!isNaN(param1))
            {
                return itemCounts[param1];
            }
            var _loc_2:Number = 0;
            for each (_loc_3 in itemCounts)
            {
                
                _loc_2 = _loc_2 + _loc_3;
            }
            return _loc_2;
        }// end function

        public static function getPaused() : Boolean
        {
            return paused;
        }// end function

        public static function setPaused(param1:Boolean = true, param2:Number = NaN) : uint
        {
            var _loc_7:Object = null;
            var _loc_8:int = 0;
            if (paused == param1)
            {
                return 0;
            }
            var _loc_3:Number = 0;
            var _loc_4:Boolean = false;
            var _loc_5:* = isNaN(param2);
            var _loc_6:* = param1 ? ("pause") : ("resume");
            for (_loc_7 in items)
            {
                
                _loc_8 = items[_loc_7] as int;
                if (_loc_5 || _loc_8 == param2)
                {
                    _loc_4 = _loc_4 || (param1 ? (removePulse(_loc_8)) : (addPulse(_loc_8)));
                    if (_loc_7.hasOwnProperty(_loc_6))
                    {
                        if (_loc_7[_loc_6] is Function)
                        {
                            _loc_7[_loc_6].apply(_loc_7);
                            _loc_3 = _loc_3 + 1;
                        }
                    }
                }
            }
            if (_loc_4)
            {
                paused = param1;
            }
            return _loc_3;
        }// end function

        private static function update(event:Event) : void
        {
            var _loc_5:Array = null;
            var _loc_6:* = undefined;
            var _loc_7:Object = null;
            var _loc_2:* = getTimer();
            var _loc_3:* = event is TimerEvent ? ((event.target as Timer).delay) : (ENTER_FRAME);
            lockedPulses[_loc_3] = true;
            var _loc_4:* = liveManagers > 0;
            if (liveManagers > 0)
            {
                _loc_5 = [];
            }
            for (_loc_6 in items)
            {
                
                if (items[_loc_6] == _loc_3 && !addQueue[_loc_6])
                {
                    (_loc_6 as IUpdatable).update(_loc_2);
                    if (_loc_4)
                    {
                        _loc_5.push(_loc_6);
                    }
                }
            }
            lockedPulses[_loc_3] = false;
            if (delayedPulses[_loc_3])
            {
                for (_loc_6 in addQueue)
                {
                    
                    delete addQueue[_loc_6];
                }
                delete delayedPulses[_loc_3];
            }
            if (_loc_4)
            {
                for each (_loc_7 in managers)
                {
                    
                    if (_loc_7 is ILiveManager)
                    {
                        (_loc_7 as ILiveManager).onUpdate(_loc_3, _loc_5, _loc_2);
                    }
                }
            }
            return;
        }// end function

        private static function addPulse(param1:int) : Boolean
        {
            if (param1 == ENTER_FRAME)
            {
                if (!pulseSprite)
                {
                    var _loc_3:* = new Sprite();
                    pulseSprite = new Sprite();
                    timers[ENTER_FRAME] = _loc_3;
                    pulseSprite.addEventListener(Event.ENTER_FRAME, update);
                }
                return true;
            }
            var _loc_2:* = timers[param1] as Timer;
            if (!_loc_2)
            {
                var _loc_3:* = new Timer(param1);
                timers[param1] = new Timer(param1);
                _loc_2 = _loc_3;
                (timers[param1] as Timer).addEventListener(TimerEvent.TIMER, update);
                _loc_2.start();
                return true;
            }
            return false;
        }// end function

        private static function removePulse(param1:int) : Boolean
        {
            if (param1 == ENTER_FRAME)
            {
                if (pulseSprite)
                {
                    pulseSprite.removeEventListener(Event.ENTER_FRAME, update);
                    delete timers[ENTER_FRAME];
                    pulseSprite = null;
                    return true;
                }
            }
            var _loc_2:* = timers[param1] as Timer;
            if (_loc_2)
            {
                _loc_2.stop();
                _loc_2.removeEventListener(TimerEvent.TIMER, update);
                delete timers[param1];
                return true;
            }
            return false;
        }// end function

    }
}
