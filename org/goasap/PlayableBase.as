package org.goasap
{
    import flash.events.*;
    import flash.utils.*;

    public class PlayableBase extends EventDispatcher
    {
        protected var _state:String = "STOPPED";
        protected var _id:Object;
        private static var _idCounter:int = -1;
        static var _playRetainer:Dictionary = new Dictionary(false);

        public function PlayableBase() : void
        {
            var _loc_1:* = getQualifiedClassName(this);
            if (_loc_1.slice(_loc_1.lastIndexOf("::") + 2) == "PlayableBase")
            {
                throw new InstanceNotAllowedError("PlayableBase");
            }
            playableID = _idCounter + 1;
            return;
        }// end function

        public function get playableID()
        {
            return _id;
        }// end function

        public function set playableID(param1) : void
        {
            _id = param1;
            return;
        }// end function

        public function get state() : String
        {
            return _state;
        }// end function

        override public function toString() : String
        {
            var _loc_1:* = super.toString();
            var _loc_2:* = _loc_1.charAt((_loc_1.length - 1)) == "]";
            if (_loc_2)
            {
                _loc_1 = _loc_1.slice(0, -1);
            }
            if (playableID is String)
            {
                _loc_1 = _loc_1 + (" playableID:\"" + playableID + "\"");
            }
            else
            {
                _loc_1 = _loc_1 + (" playableID:" + playableID);
            }
            if (_loc_2)
            {
                _loc_1 = _loc_1 + "]";
            }
            return _loc_1;
        }// end function

    }
}
