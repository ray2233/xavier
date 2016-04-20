package com.hydrotik.go
{
    import flash.utils.*;
    import org.goasap.interfaces.*;

    public class PV3DRenderManager extends Object implements ILiveManager
    {
        protected var handlers:Dictionary;
        private static var _viewport:Object;
        private static var _camera:Object;
        private static var _scene:Object;
        private static var _renderer:Object;
        private static var _lookAtTarget:Object;

        public function PV3DRenderManager()
        {
            handlers = new Dictionary(false);
            return;
        }// end function

        public function reserve(param1:IManageable) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = (param1 as IRenderable).getRenderer();
            for (_loc_3 in _loc_2)
            {
                
                if (_loc_3 == "viewport")
                {
                    _viewport = _loc_2[_loc_3];
                    continue;
                }
                if (_loc_3 == "camera")
                {
                    _camera = _loc_2[_loc_3];
                    continue;
                }
                if (_loc_3 == "scene")
                {
                    _scene = _loc_2[_loc_3];
                    continue;
                }
                if (_loc_3 == "renderer")
                {
                    _renderer = _loc_2[_loc_3];
                    continue;
                }
                if (_loc_3 == "lookAtTarget")
                {
                    _lookAtTarget = _loc_2[_loc_3];
                }
            }
            return;
        }// end function

        public function release(param1:IManageable) : void
        {
            return;
        }// end function

        public function onUpdate(param1:int, param2:Array, param3:Number) : void
        {
            if (_renderer != null)
            {
                _renderer.renderScene(_scene, _camera, _viewport);
            }
            if (_lookAtTarget != null)
            {
                _camera.lookAt(_lookAtTarget);
            }
            return;
        }// end function

    }
}
