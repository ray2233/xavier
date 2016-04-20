package vhss.events
{
    import flash.events.*;

    public class DataLoaderEvent extends Event
    {
        public var data:Object;
        public static const DEFAULT_NAME:String = "vhss.events.DataLoaderEvent";
        public static const ON_DATA_READY:String = "dataReady";

        public function DataLoaderEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
            this.data = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new DataLoaderEvent(type, this.data, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("DataLoaderEvent", "data", "type", "bubbles", "cancelable");
        }// end function

    }
}
