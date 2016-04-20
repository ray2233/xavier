package com.oddcast.assets.structures
{
    import flash.display.*;

    public class LoadedAssetStruct extends Object
    {
        public var id:int;
        public var url:String;
        public var type:String;
        public var loader:Loader;
        public var display_obj:DisplayObject;
        public var name:String;
        public var catId:int;
        public var catName:String;

        public function LoadedAssetStruct(param1:String = null, param2:int = 0, param3:String = null)
        {
            id = param2;
            url = param1;
            type = param3;
            return;
        }// end function

        public function destroy() : void
        {
            display_obj = null;
            loader = null;
            return;
        }// end function

    }
}
