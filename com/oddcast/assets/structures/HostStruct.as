package com.oddcast.assets.structures
{
    import flash.display.*;

    public class HostStruct extends LoadedAssetStruct
    {
        public var model_ptr:MovieClip;
        public var host_container:MovieClip;
        public var cs:String;
        public var engine:EngineStruct;
        public static const HOST_2D:String = "host_2d";
        public static const HOST_3D:String = "host_3d";
        public static const HOST_FB_3D:String = "host_fb3d";

        public function HostStruct(param1:String = null, param2:uint = 0, param3:String = "host_2d")
        {
            engine = new EngineStruct();
            super(param1, param2, param3);
            return;
        }// end function

    }
}
