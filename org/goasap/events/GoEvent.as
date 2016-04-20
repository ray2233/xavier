package org.goasap.events
{
    import flash.events.*;

    public class GoEvent extends Event
    {
        public var extra:Object;
        public static const START:String = "playableStart";
        public static const UPDATE:String = "playableUpdate";
        public static const PAUSE:String = "playablePause";
        public static const RESUME:String = "playableResume";
        public static const CYCLE:String = "playableCycle";
        public static const STOP:String = "playableStop";
        public static const COMPLETE:String = "playableComplete";

        public function GoEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
