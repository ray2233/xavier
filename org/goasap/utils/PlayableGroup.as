package org.goasap.utils
{
    import flash.utils.*;
    import org.goasap.*;
    import org.goasap.events.*;
    import org.goasap.interfaces.*;
    import org.goasap.managers.*;

    public class PlayableGroup extends PlayableBase implements IPlayable
    {
        protected var _children:Dictionary;
        protected var _listeners:uint = 0;
        protected var _repeater:Repeater;

        public function PlayableGroup(... args)
        {
            _children = new Dictionary();
            if (args.length > 0)
            {
                this.children = args[0] is Array ? (args[0]) : (args);
            }
            _repeater = new Repeater();
            _repeater.setParent(this);
            return;
        }// end function

        public function get children() : Array
        {
            var _loc_2:Object = null;
            var _loc_1:Array = [];
            for (_loc_2 in _children)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function set children(param1:Array) : void
        {
            var _loc_2:Object = null;
            if (_listeners > 0)
            {
                stop();
            }
            for each (_loc_2 in param1)
            {
                
                if (_loc_2 is IPlayable)
                {
                    addChild(_loc_2 as IPlayable);
                }
            }
            return;
        }// end function

        public function get repeater() : Repeater
        {
            return _repeater;
        }// end function

        public function get listenerCount() : uint
        {
            return _listeners;
        }// end function

        public function getChildByID(param1, param2:Boolean = true) : IPlayable
        {
            var _loc_3:Object = null;
            var _loc_4:IPlayable = null;
            for (_loc_3 in _children)
            {
                
                if (_loc_3.hasOwnProperty("playableID") && _loc_3["playableID"] === param1)
                {
                    return _loc_3 as IPlayable;
                }
            }
            if (param2)
            {
                for (_loc_3 in _children)
                {
                    
                    if (_loc_3 is PlayableGroup)
                    {
                        _loc_4 = (_loc_3 as PlayableGroup).getChildByID(param1, true);
                        if (_loc_4)
                        {
                            return _loc_4 as IPlayable;
                        }
                    }
                }
            }
            return null;
        }// end function

        public function addChild(param1:IPlayable, param2:Boolean = false) : Boolean
        {
            var _loc_3:IPlayable = null;
            var _loc_4:Boolean = false;
            var _loc_5:IPlayable = null;
            var _loc_6:Boolean = false;
            if (_children[param1])
            {
                return false;
            }
            if (param1.state != _state)
            {
                _loc_3 = param2 ? (param1) : (this);
                _loc_4 = _loc_3.state == PlayStates.PLAYING || _loc_3.state == PlayStates.PLAYING_DELAY;
                _loc_5 = param2 ? (this) : (param1);
                _loc_6 = _loc_5.state == PlayStates.PLAYING || _loc_5.state == PlayStates.PLAYING_DELAY;
                if (!(_loc_4 && _loc_6))
                {
                    switch(_loc_3.state)
                    {
                        case PlayStates.STOPPED:
                        {
                            _loc_5.stop();
                            break;
                        }
                        case PlayStates.PAUSED:
                        {
                            if (_loc_5.state == PlayStates.STOPPED)
                            {
                                _loc_5.start();
                            }
                            _loc_5.pause();
                            break;
                        }
                        case PlayStates.PLAYING:
                        case PlayStates.PLAYING_DELAY:
                        {
                            if (_loc_5.state == PlayStates.PAUSED)
                            {
                                _loc_5.resume();
                            }
                            else if (_loc_5.state == PlayStates.STOPPED)
                            {
                                if (param2)
                                {
                                    _state = PlayStates.PLAYING;
                                    dispatchEvent(new GoEvent(GoEvent.START));
                                }
                                else
                                {
                                    _loc_5.start();
                                }
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            _children[param1] = false;
            if (_state != PlayStates.STOPPED)
            {
                listenTo(param1);
            }
            return true;
        }// end function

        public function removeChild(param1:IPlayable) : Boolean
        {
            var _loc_2:* = _children[param1];
            if (_loc_2 === null)
            {
                return false;
            }
            if (_loc_2 === true)
            {
                unListenTo(param1);
            }
            delete _children[param1];
            return true;
        }// end function

        public function anyChildHasState(param1:String) : Boolean
        {
            var _loc_2:Object = null;
            for (_loc_2 in _children)
            {
                
                if ((_loc_2 as IPlayable).state == param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function start() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_3:Boolean = false;
            stop();
            var _loc_1:Boolean = false;
            for (_loc_2 in _children)
            {
                
                _loc_3 = (_loc_2 as IPlayable).start();
                if (_loc_3)
                {
                    listenTo(_loc_2 as IPlayable);
                }
                _loc_1 = _loc_3 || _loc_1;
            }
            if (!_loc_1)
            {
                return false;
            }
            _state = PlayStates.PLAYING;
            dispatchEvent(new GoEvent(GoEvent.START));
            _playRetainer[this] = 1;
            return true;
        }// end function

        public function stop() : Boolean
        {
            var _loc_2:Object = null;
            if (_state == PlayStates.STOPPED)
            {
                return false;
            }
            _state = PlayStates.STOPPED;
            _repeater.reset();
            delete _playRetainer[this];
            if (_listeners == 0)
            {
                dispatchEvent(new GoEvent(GoEvent.COMPLETE));
                return true;
            }
            var _loc_1:Boolean = true;
            for (_loc_2 in _children)
            {
                
                unListenTo(_loc_2 as IPlayable);
                _loc_1 = (_loc_2 as IPlayable).stop() && _loc_1;
            }
            dispatchEvent(new GoEvent(GoEvent.STOP));
            return _loc_1;
        }// end function

        public function pause() : Boolean
        {
            var _loc_3:Object = null;
            var _loc_4:Boolean = false;
            if (_state != PlayStates.PLAYING)
            {
                return false;
            }
            var _loc_1:Boolean = true;
            var _loc_2:uint = 0;
            for (_loc_3 in _children)
            {
                
                _loc_4 = (_loc_3 as IPlayable).pause();
                if (_loc_4)
                {
                    _loc_2 = _loc_2 + 1;
                }
                _loc_1 = _loc_1 && _loc_4;
            }
            if (_loc_2 > 0)
            {
                _state = PlayStates.PAUSED;
                dispatchEvent(new GoEvent(GoEvent.PAUSE));
            }
            return _loc_2 > 0 && _loc_1;
        }// end function

        public function resume() : Boolean
        {
            var _loc_3:Object = null;
            var _loc_4:Boolean = false;
            if (_state != PlayStates.PAUSED)
            {
                return false;
            }
            var _loc_1:Boolean = true;
            var _loc_2:uint = 0;
            for (_loc_3 in _children)
            {
                
                _loc_4 = (_loc_3 as IPlayable).resume();
                if (_loc_4)
                {
                    _loc_2 = _loc_2 + 1;
                }
                _loc_1 = _loc_1 && _loc_4;
            }
            if (_loc_2 > 0)
            {
                _state = PlayStates.PLAYING;
                dispatchEvent(new GoEvent(GoEvent.RESUME));
            }
            return _loc_2 > 0 && _loc_1;
        }// end function

        public function skipTo(param1:Number) : Boolean
        {
            var _loc_4:Object = null;
            var _loc_2:Boolean = true;
            var _loc_3:uint = 0;
            param1 = _repeater.skipTo(_repeater.cycles, param1);
            for (_loc_4 in _children)
            {
                
                _loc_2 = (_loc_4 as IPlayable).skipTo(param1) && _loc_2;
                listenTo(_loc_4 as IPlayable);
                _loc_3 = _loc_3 + 1;
            }
            _state = _loc_2 ? (PlayStates.PLAYING) : (PlayStates.STOPPED);
            return _loc_3 > 0 && _loc_2;
        }// end function

        protected function onItemEnd(event:GoEvent) : void
        {
            unListenTo(event.target as IPlayable);
            if (_listeners == 0)
            {
                complete();
            }
            return;
        }// end function

        protected function complete() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Boolean = false;
            if (_repeater.next())
            {
                dispatchEvent(new GoEvent(GoEvent.CYCLE));
                for (_loc_1 in _children)
                {
                    
                    _loc_2 = (_loc_1 as IPlayable).start();
                    if (_loc_2)
                    {
                        listenTo(_loc_1 as IPlayable);
                    }
                }
            }
            else
            {
                stop();
            }
            return;
        }// end function

        protected function listenTo(param1:IPlayable) : void
        {
            if (_children[param1] === false)
            {
                param1.addEventListener(GoEvent.STOP, onItemEnd, false, 0, true);
                param1.addEventListener(GoEvent.COMPLETE, onItemEnd, false, 0, true);
                _children[param1] = true;
                var _loc_3:* = _listeners + 1;
                _listeners = _loc_3;
            }
            return;
        }// end function

        protected function unListenTo(param1:IPlayable) : void
        {
            if (_children[param1] === true)
            {
                param1.removeEventListener(GoEvent.STOP, onItemEnd);
                param1.removeEventListener(GoEvent.COMPLETE, onItemEnd);
                _children[param1] = false;
                var _loc_3:* = _listeners - 1;
                _listeners = _loc_3;
            }
            return;
        }// end function

    }
}
