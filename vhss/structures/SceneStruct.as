package vhss.structures
{
    import com.oddcast.assets.structures.*;
    import com.pagodaflash.data.*;

    public class SceneStruct extends Object
    {
        public var id:String;
        public var number:Number;
        public var auto_advance:Boolean;
        public var advance_delay:Number;
        public var mouse_follow:Number;
        public var playback_limit:Number;
        public var playback_interval:Number;
        public var host_x:Number = 0;
        public var host_y:Number = 0;
        public var host_scale:Number = 100;
        public var host_visible:Boolean = true;
        public var host_exp:String;
        public var host_exp_intensity:Number = 1;
        public var bg_visible:Boolean = true;
        public var play_mode:String = "";
        public var title:String;
        public var audio:AudioStruct;
        public var assets_to_load:Number = 0;
        public var link:LinkStruct;
        private var _skin_conf:XML;
        private var host_data:HostStruct;
        private var bg_data:BackgroundStruct;
        private var skin_data:SkinStruct;
        private var _backgroundTransform:Object;

        public function SceneStruct()
        {
            _backgroundTransform = {x:0, y:0, rotation:0, scaleX:1, scaleY:1};
            return;
        }// end function

        public function set host(param1:HostStruct) : void
        {
            if (param1 && param1.url)
            {
                var _loc_3:* = assets_to_load + 1;
                assets_to_load = _loc_3;
            }
            host_data = param1;
            return;
        }// end function

        public function get host() : HostStruct
        {
            return host_data;
        }// end function

        public function set bg(param1:BackgroundStruct) : void
        {
            if (param1 && param1.url)
            {
                var _loc_3:* = assets_to_load + 1;
                assets_to_load = _loc_3;
                bg_data = param1;
            }
            return;
        }// end function

        public function get bg() : BackgroundStruct
        {
            return bg_data;
        }// end function

        public function get backgroundTransform() : Object
        {
            return ObjectUtil.duplicate(_backgroundTransform);
        }// end function

        public function set backgroundTransform(param1:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in param1)
            {
                
                _backgroundTransform[_loc_2] = param1[_loc_2];
            }
            return;
        }// end function

        public function set skin(param1:SkinStruct) : void
        {
            if (param1 && param1.url)
            {
                var _loc_3:* = assets_to_load + 1;
                assets_to_load = _loc_3;
                skin_data = param1;
            }
            else
            {
                skin_data = null;
            }
            return;
        }// end function

        public function get skin() : SkinStruct
        {
            return skin_data;
        }// end function

        public function set skin_conf(param1:XML) : void
        {
            _skin_conf = param1;
            title = param1.@TITLE;
            return;
        }// end function

        public function get skin_conf() : XML
        {
            return _skin_conf;
        }// end function

    }
}
