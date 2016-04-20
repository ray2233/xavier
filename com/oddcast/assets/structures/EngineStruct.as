package com.oddcast.assets.structures
{

    public class EngineStruct extends LoadedAssetStruct
    {
        public var ctlUrl:String;
        public var version:String;
        public static const ENGINE_2D:String = "2d";
        public static const ENGINE_3D:String = "3d";
        public static const ENGINE_FB:String = "FB";

        public function EngineStruct(param1:String = null, param2:uint = 0, param3:String = "2d")
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
