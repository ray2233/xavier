package org.goasap.items
{
    import org.goasap.errors.*;
    import org.goasap.interfaces.*;
    import org.goasap.managers.*;

    public class LinearGo extends GoItem implements IPlayable
    {
        protected var _delay:Number;
        protected var _duration:Number;
        protected var _tweenDuration:Number;
        protected var _easing:Function;
        protected var _easeParams:Array;
        protected var _extraEaseParams:Array;
        protected var _repeater:LinearGoRepeater;
        protected var _currentEasing:Function;
        protected var _useFrames:Boolean;
        protected var _started:Boolean = false;
        protected var _currentFrame:int;
        protected var _position:Number;
        protected var _change:Number;
        protected var _startTime:Number;
        protected var _endTime:Number;
        protected var _pauseTime:Number;
        protected var _callbacks:Object;
        public static var defaultDelay:Number = 0;
        public static var defaultDuration:Number = 1;
        public static var defaultEasing:Function;
        static var _useFramesMode:Boolean = false;
        static var _framesBase:Number = 1;

        public function LinearGo(param1:Number = NaN, param2:Number = NaN, param3:Function = null, param4:Array = null, param5:LinearGoRepeater = null, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Number = NaN)
        {
            var delay:* = param1;
            var duration:* = param2;
            var easing:* = param3;
            var extraEasingParams:* = param4;
            var repeater:* = param5;
            var useRelative:* = param6;
            var useRounding:* = param7;
            var useFrames:* = param8;
            var pulseInterval:* = param9;
            _callbacks = new Object();
            if (isNaN(defaultDelay))
            {
                defaultDelay = 0;
            }
            if (isNaN(defaultDuration))
            {
                defaultDuration = 1;
            }
            try
            {
                this.easing = defaultEasing;
            }
            catch (e1:EasingFormatError)
            {
                defaultEasing = easeOut;
            }
            if (!isNaN(delay))
            {
                _delay = delay;
            }
            else
            {
                _delay = defaultDelay;
            }
            if (!isNaN(duration))
            {
                _duration = duration;
            }
            else
            {
                _duration = defaultDuration;
            }
            try
            {
                this.easing = easing;
            }
            catch (e2:EasingFormatError)
            {
                if (easing != null)
                {
                    throw e2;
                }
                this.easing = defaultEasing;
            }
            if (extraEasingParams)
            {
                _extraEaseParams = extraEasingParams;
            }
            if (useRelative)
            {
                this.useRelative = true;
            }
            if (useRounding)
            {
                this.useRounding = true;
            }
            _useFrames = useFrames || _useFramesMode;
            if (!isNaN(pulseInterval))
            {
                _pulse = pulseInterval;
            }
            if (repeater != null)
            {
                _repeater = repeater;
            }
            else
            {
                _repeater = new LinearGoRepeater();
            }
            _repeater.setParent(this);
            return;
        }// end function

        public function get delay() : Number
        {
            return _delay;
        }// end function

        public function set delay(param1:Number) : void
        {
            if (_state == PlayStates.STOPPED && param1 >= 0)
            {
                _delay = param1;
            }
            return;
        }// end function

        public function get duration() : Number
        {
            return _duration;
        }// end function

        public function set duration(param1:Number) : void
        {
            if (_state == PlayStates.STOPPED && param1 >= 0)
            {
                _duration = param1;
            }
            return;
        }// end function

        public function get easing() : Function
        {
            return _easing;
        }// end function

        public function set easing(param1:Function) : void
        {
            var type:* = param1;
            if (_state == PlayStates.STOPPED)
            {
                try
                {
                    if (this.type(1, 1, 1, 1) is Number)
                    {
                        _easing = type;
                        return;
                    }
                }
                catch (e:Error)
                {
                }
                throw new EasingFormatError();
            }
            return;
        }// end function

        public function get extraEasingParams() : Array
        {
            return _extraEaseParams;
        }// end function

        public function set extraEasingParams(param1:Array) : void
        {
            if (_state == PlayStates.STOPPED && param1 is Array && param1.length > 0)
            {
                _extraEaseParams = param1;
            }
            return;
        }// end function

        public function get repeater() : LinearGoRepeater
        {
            return _repeater;
        }// end function

        public function set useFrames(param1:Boolean) : void
        {
            if (_state == PlayStates.STOPPED)
            {
                _useFrames = param1;
            }
            return;
        }// end function

        public function get useFrames() : Boolean
        {
            return _useFrames;
        }// end function

        public function get position() : Number
        {
            return _position;
        }// end function

        public function get timePosition() : Number
        {
            var _loc_2:uint = 0;
            if (_state == PlayStates.STOPPED)
            {
                return 0;
            }
            var _loc_1:* = Math.max(0, timeMultiplier);
            if (_useFrames)
            {
                if (_currentFrame > _framesBase)
                {
                    _loc_2 = _currentFrame - _framesBase;
                    if (_repeater.direction == -1)
                    {
                        return (_duration - 1) - _loc_2 % _duration + _framesBase;
                    }
                    return _loc_2 % _duration + _framesBase;
                }
                return _currentFrame;
            }
            return (getTimer() - _startTime) / 1000 / _loc_1;
        }// end function

        public function get currentFrame() : uint
        {
            return _currentFrame;
        }// end function

        public function start() : Boolean
        {
            stop();
            if (GoEngine.addItem(this) == false)
            {
                return false;
            }
            reset();
            _state = _delay > 0 ? (PlayStates.PLAYING_DELAY) : (PlayStates.PLAYING);
            return true;
        }// end function

        public function stop() : Boolean
        {
            if (_state == PlayStates.STOPPED || GoEngine.removeItem(this) == false)
            {
                return false;
            }
            _state = PlayStates.STOPPED;
            var _loc_1:* = _easeParams != null && _position == _easeParams[1] + _change;
            reset();
            if (!_loc_1)
            {
                dispatch(GoEvent.STOP);
            }
            return true;
        }// end function

        public function pause() : Boolean
        {
            if (_state == PlayStates.STOPPED || _state == PlayStates.PAUSED)
            {
                return false;
            }
            _state = PlayStates.PAUSED;
            _pauseTime = _useFrames ? (_currentFrame) : (getTimer());
            dispatch(GoEvent.PAUSE);
            return true;
        }// end function

        public function resume() : Boolean
        {
            if (_state != PlayStates.PAUSED)
            {
                return false;
            }
            var _loc_1:* = _useFrames ? (_currentFrame) : (getTimer());
            setup(_loc_1 - (_pauseTime - _startTime));
            _pauseTime = NaN;
            _state = _startTime > _loc_1 ? (PlayStates.PLAYING_DELAY) : (PlayStates.PLAYING);
            dispatch(GoEvent.RESUME);
            return true;
        }// end function

        public function skipTo(param1:Number) : Boolean
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (_state == PlayStates.STOPPED)
            {
                if (start() == false)
                {
                    return false;
                }
            }
            if (isNaN(param1))
            {
                param1 = 0;
            }
            var _loc_2:* = Math.max(0, timeMultiplier) * (_useFrames ? (1) : (1000));
            if (param1 < _framesBase)
            {
                _repeater.reset();
                if (_position > 0)
                {
                    skipTo(_framesBase);
                }
            }
            else
            {
                param1 = _repeater.skipTo(_duration, param1 - _framesBase);
            }
            if (_useFrames)
            {
                _loc_3 = _framesBase;
                var _loc_5:* = Math.round(param1 * _loc_2);
                _currentFrame = Math.round(param1 * _loc_2);
                _loc_4 = _loc_5;
            }
            else
            {
                _loc_4 = getTimer();
                _loc_3 = _loc_4 - param1 * _loc_2;
            }
            setup(_loc_3);
            _state = _startTime > _loc_4 ? (PlayStates.PLAYING_DELAY) : (PlayStates.PLAYING);
            update(_loc_4);
            return true;
        }// end function

        public function addCallback(param1:Function, param2:String = "playableComplete") : void
        {
            if (!_callbacks[param2])
            {
                _callbacks[param2] = new Array();
            }
            var _loc_3:* = _callbacks[param2] as Array;
            if (_loc_3.indexOf(param1) == -1)
            {
                _loc_3.push(param1);
            }
            return;
        }// end function

        public function removeCallback(param1:Function, param2:String = "playableComplete") : void
        {
            var _loc_3:* = _callbacks[param2] as Array;
            if (_loc_3)
            {
                while (_loc_3.indexOf(param1) > -1)
                {
                    
                    _loc_3.splice(_loc_3.indexOf(param1), 1);
                }
            }
            return;
        }// end function

        override public function update(param1:Number) : void
        {
            if (_state == PlayStates.PAUSED)
            {
                return;
            }
            var _loc_4:* = _currentFrame + 1;
            _currentFrame = _loc_4;
            if (_useFrames)
            {
                param1 = _currentFrame;
            }
            if (isNaN(_startTime))
            {
                setup(param1);
            }
            if (_startTime > param1)
            {
                return;
            }
            var _loc_2:* = GoEvent.UPDATE;
            if (param1 < _endTime)
            {
                if (!_started)
                {
                    _loc_2 = GoEvent.START;
                }
                _easeParams[0] = param1 - _startTime;
                _position = _currentEasing.apply(null, _easeParams);
            }
            else
            {
                _position = _easeParams[1] + _change;
                _loc_2 = _repeater.hasNext() ? (GoEvent.CYCLE) : (GoEvent.COMPLETE);
            }
            onUpdate(_loc_2);
            if (!_started)
            {
                _state = PlayStates.PLAYING;
                _started = true;
                dispatch(GoEvent.START);
            }
            dispatch(GoEvent.UPDATE);
            if (_loc_2 == GoEvent.COMPLETE)
            {
                stop();
                dispatch(GoEvent.COMPLETE);
            }
            else if (_loc_2 == GoEvent.CYCLE)
            {
                _repeater.next();
                dispatch(GoEvent.CYCLE);
                _startTime = NaN;
            }
            return;
        }// end function

        protected function onUpdate(param1:String) : void
        {
            return;
        }// end function

        protected function setup(param1:Number) : void
        {
            var _loc_5:Number = NaN;
            _startTime = param1;
            var _loc_2:* = Math.max(0, timeMultiplier) * (_useFrames ? (1) : (1000));
            _tweenDuration = _useFrames ? ((Math.round(_duration * _loc_2) - 1)) : (_duration * _loc_2);
            _endTime = _startTime + _tweenDuration;
            if (!_started)
            {
                _loc_5 = _useFrames ? (Math.round(_delay * _loc_2)) : (_delay * _loc_2);
                _startTime = _startTime + _loc_5;
                _endTime = _endTime + _loc_5;
            }
            var _loc_3:* = _repeater.currentCycleHasEasing;
            _currentEasing = _loc_3 ? (_repeater.easingOnCycle) : (_easing);
            var _loc_4:* = _loc_3 ? (_repeater.extraEasingParams) : (_extraEaseParams);
            _change = _repeater.direction;
            _position = _repeater.direction == -1 ? (1) : (0);
            _easeParams = new Array(0, _position, _change, _tweenDuration);
            if (_loc_4)
            {
                _easeParams = _easeParams.concat(_loc_4);
            }
            return;
        }// end function

        protected function dispatch(param1:String) : void
        {
            var _loc_3:Function = null;
            var _loc_2:* = _callbacks[param1] as Array;
            if (_loc_2)
            {
                for each (_loc_3 in _loc_2)
                {
                    
                    this._loc_3();
                }
            }
            if (hasEventListener(param1))
            {
                dispatchEvent(new GoEvent(param1));
            }
            return;
        }// end function

        protected function reset() : void
        {
            _position = 0;
            _change = 1;
            _repeater.reset();
            _currentFrame = _framesBase - 1;
            _currentEasing = _easing;
            _easeParams = null;
            _started = false;
            _pauseTime = NaN;
            _startTime = NaN;
            return;
        }// end function

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4 - 1;
            param1 = param1 / param4 - 1;
            return param3 * (_loc_5 * param1 * param1 * param1 * param1 + 1) + param2;
        }// end function

        public static function easeNone(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param3 * param1 / param4 + param2;
        }// end function

        public static function setupUseFramesMode(param1:Boolean = true, param2:Boolean = false) : void
        {
            GoItem.defaultPulseInterval = GoEngine.ENTER_FRAME;
            _useFramesMode = param1;
            if (param2)
            {
                _framesBase = 0;
            }
            return;
        }// end function

    }
}
