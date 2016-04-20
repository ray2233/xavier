package vhss.events
{
    import flash.events.*;

    public class AssetEvent extends Event
    {
        public var data:Object;
        public static const ASSET_LOADED:String = "asset_loaded";
        public static const ASSET_ERROR:String = "asset_error";
        public static const ASSET_INIT:String = "asset_init";

        public function AssetEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) : void
        {
            super(param1, param3, param4);
            data = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AssetEvent(type, data, bubbles, cancelable);
        }// end function

        override public function toString() : String
        {
            return formatToString("AssetEvent", "data", "type", "bubbles", "cancelable");
        }// end function

    }
}
