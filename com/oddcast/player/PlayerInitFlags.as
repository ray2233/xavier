package com.oddcast.player
{

    public class PlayerInitFlags extends Object
    {
        public static var TRACKING_OFF:int = 1;
        public static var IGNORE_PLAY_ON_LOAD:int = 2;
        public static var SUPPRESS_EXPORT_XML:int = 4;
        public static var SUPPRESS_3D_OFFSET:int = 8;
        public static var SUPPRESS_PLAY_ON_CLICK:int = 16;
        public static var SUPPRESS_LINKS:int = 32;
        public static var SUPPRESS_AUTO_ADV:int = 64;
        public static var DISABLE_SHARED_OBJECT_COOKIES:int = 128;

        public function PlayerInitFlags()
        {
            return;
        }// end function

    }
}
