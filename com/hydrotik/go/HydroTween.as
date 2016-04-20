package com.hydrotik.go
{
    import com.hydrotik.go.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;
    import org.goasap.interfaces.*;
    import org.goasap.items.*;
    import org.goasap.managers.*;

    public class HydroTween extends LinearGo implements IRenderable
    {
        protected var _target:Object;
        protected var _closure:Function;
        protected var _update:Function;
        protected var _tweenStartProps:Dictionary;
        protected var _tweenList:Dictionary;
        protected var _matrix:Array;
        protected var _changeMatrix:Array;
        protected var _startMatrix:Array;
        protected var _propsTo:Object;
        protected var _updateArgs:Array;
        protected var _closureArgs:Array;
        protected var _scope:Object;
        protected var _propInitialized:Boolean = false;
        public static var VERBOSE:Boolean = true;
        public static var PULSE:Number = -1;
        public static const VERSION:String = "HydroTween 0.5.1e rev43";
        public static const INFO:String = VERSION + " (c) Donovan Adams/Moses Gunesch, MIT Licensed.";
        static const DELTA_INDEX:Array = [0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.2, 0.21, 0.22, 0.24, 0.25, 0.27, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 0.71, 0.74, 0.77, 0.8, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 1, 1.06, 1.12, 1.18, 1.24, 1.3, 1.36, 1.42, 1.48, 1.54, 1.6, 1.66, 1.72, 1.78, 1.84, 1.9, 1.96, 2, 2.12, 2.25, 2.37, 2.5, 2.62, 2.75, 2.87, 3, 3.2, 3.4, 3.6, 3.8, 4, 4.3, 4.7, 4.9, 5, 5.5, 6, 6.5, 6.8, 7, 7.3, 7.5, 7.8, 8, 8.4, 8.7, 9, 9.4, 9.6, 9.8, 10];
        public static const IDENTITY:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
        static const _r_lum:Number = 0.212671;
        static const _g_lum:Number = 0.71516;
        static const _b_lum:Number = 0.072169;
        public static var AUTOGC:Boolean = true;
        public static const RESET:int = -1;
        static var _propertyList:Dictionary = new Dictionary(false);
        static var _init:Boolean = false;
        static var _viewport:Object;
        static var _camera:Object;
        static var _scene:Object;
        static var _renderer:Object;
        static var _init3D:Boolean;
        static var _lookAtTarget:Object;
        static var debug:Function;

        public function HydroTween(param1:Object = null, param2:Object = null, param3:Number = NaN, param4:Number = NaN, param5:Function = null, param6:Function = null, param7:Function = null, param8:Array = null, param9:Array = null, param10:Array = null, param11:Object = null, param12:Boolean = false, param13:Boolean = false, param14:Number = NaN)
        {
            _tweenStartProps = new Dictionary(true);
            _tweenList = new Dictionary(true);
            _matrix = [];
            _changeMatrix = [];
            _startMatrix = [];
            super(param4, param3, param5, param10, param11 == null ? (null) : (param11 is LinearGoRepeater ? (param11 as LinearGoRepeater) : (new LinearGoRepeater(param11.cycles, param11.reverse, param11.easing))), param12, param13, useFrames, param14);
            init();
            _update = param7;
            _updateArgs = param9;
            _target = param1;
            if (AUTOGC)
            {
                addCallback(dispose);
            }
            _closure = param6;
            _closureArgs = param8;
            if (param2)
            {
                setProps(param2);
            }
            return;
        }// end function

        public function setTarget(param1:Object) : void
        {
            _target = param1;
            return;
        }// end function

        public function setClosure(param1:Function) : void
        {
            _closure = param1;
            return;
        }// end function

        public function setClosureArgs(param1:Array) : void
        {
            _closureArgs = param1;
            return;
        }// end function

        public function setUpdate(param1:Function) : void
        {
            _update = param1;
            return;
        }// end function

        public function setUpdateArgs(param1:Array) : void
        {
            _updateArgs = param1;
            return;
        }// end function

        public function setScope(param1) : void
        {
            _scope = param1;
            return;
        }// end function

        public function setProps(param1:Object) : void
        {
            var _loc_2:String = null;
            _propsTo = param1;
            return;
        }// end function

        protected function propInit() : Boolean
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:Boolean = false;
            var _loc_4:Object = null;
            if (_target != null)
            {
                _matrix = _propsTo["matrix"] == null ? (_propsTo["color"] != null ? (IDENTITY) : (cmRead(_target))) : (_propsTo["matrix"]);
            }
            for (_loc_2 in _propsTo)
            {
                
                _loc_3 = _loc_2.indexOf("start_") == 0;
                _loc_1 = _loc_3 ? (_loc_2.slice(6)) : (_loc_2);
                if (_propertyList.hasOwnProperty(_loc_1))
                {
                    if (_loc_3)
                    {
                        if (_propertyList[_loc_1].prop != "matrix")
                        {
                            _tweenStartProps[_loc_1] = _propsTo[_loc_2];
                        }
                        continue;
                    }
                    switch(_propertyList[_loc_1].prop)
                    {
                        case "matrix":
                        {
                            _startMatrix = _propertyList[_loc_1].read(_target, _loc_2);
                            _tweenList[_loc_2] = {end:_propsTo[_loc_2], write:_propertyList[_loc_2].write};
                            break;
                        }
                        case "color":
                        {
                            _tweenList[_loc_2] = {end:_propsTo[_loc_2], write:_propertyList[_loc_2].write};
                            break;
                        }
                        default:
                        {
                            _tweenList[_loc_2] = {end:_propsTo[_loc_2], write:_propertyList[_loc_2].write};
                            break;
                            break;
                        }
                    }
                }
            }
            if (!_target)
            {
                return false;
            }
            for (_loc_1 in _tweenList)
            {
                
                _loc_4 = _tweenList[_loc_1];
                if (_propertyList[_loc_1].prop != "matrix")
                {
                    if (isNaN(_tweenStartProps[_loc_1]))
                    {
                        _loc_4.start = _propertyList[_loc_1].prop == "color" ? (_propertyList[_loc_1].read(_target, _loc_1, _tweenList)) : (_propertyList[_loc_1].read(_target, _loc_1));
                    }
                    else
                    {
                        _loc_4.start = _tweenStartProps[_loc_1];
                        _loc_4.write(_target, _loc_1, _loc_4.start);
                    }
                    _loc_4.change = useRelative ? (_loc_4.end) : (_loc_4.end - _loc_4.start);
                    continue;
                }
                _matrix = _loc_4.end is Array ? (_loc_4.end) : (_propertyList[_loc_1].adjust(_matrix, isNaN(_tweenStartProps[_loc_1]) ? (_loc_4.end) : (_tweenStartProps[_loc_1])));
                _changeMatrix = useRelative ? (_matrix) : (_matrix.map(matrixSubtraction));
            }
            _propInitialized = true;
            return true;
        }// end function

        override public function start() : Boolean
        {
            if (!propInit())
            {
                return false;
            }
            return super.start();
        }// end function

        override protected function onUpdate(param1:String) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            for (_loc_2 in _tweenList)
            {
                
                _loc_3 = _tweenList[_loc_2];
                switch(_propertyList[_loc_2].prop)
                {
                    case "matrix":
                    {
                        _loc_3.write(_target, _loc_2, _matrix.map(matrixWrite));
                        break;
                    }
                    case "color":
                    {
                        _loc_3.write(_target, _loc_2, super.correctValue(_position), _loc_3.start, _loc_3.end, _tweenList);
                        break;
                    }
                    default:
                    {
                        _loc_3.write(_target, _loc_2, super.correctValue(_loc_3.start + _loc_3.change * _position), _loc_3.end);
                        break;
                        break;
                    }
                }
            }
            if (_update != null)
            {
                _update.apply(_scope, _updateArgs);
            }
            if (param1 == GoEvent.COMPLETE)
            {
                if (_closure != null)
                {
                    _closure.apply(_scope != null ? (_scope) : (null), _closureArgs != null ? (_closureArgs) : (null));
                }
            }
            return;
        }// end function

        protected function dispose() : void
        {
            var _loc_1:String = null;
            for (_loc_1 in _propsTo)
            {
                
                _propsTo[_loc_1] = null;
                _tweenList[_loc_1] = null;
            }
            _target = null;
            _propsTo = null;
            _tweenList = null;
            _closure = null;
            _update = null;
            _closureArgs = null;
            _updateArgs = null;
            _scope = null;
            _matrix = null;
            _tweenStartProps = null;
            _changeMatrix = null;
            _startMatrix = null;
            return;
        }// end function

        public function getActiveTargets() : Array
        {
            return [_target];
        }// end function

        public function getActiveProperties() : Array
        {
            var _loc_2:String = null;
            var _loc_1:* = new Array();
            for (_loc_2 in _tweenList)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function isHandling(param1:Array) : Boolean
        {
            var _loc_2:String = null;
            for (_loc_2 in _tweenList)
            {
                
                if (!isNaN(_tweenList[_loc_2].end))
                {
                    if (param1.indexOf(_loc_2) > -1)
                    {
                        return true;
                    }
                }
            }
            return false;
        }// end function

        public function releaseHandling(... args) : void
        {
            super.stop();
            return;
        }// end function

        public function getRenderer() : Object
        {
            return {renderer:_renderer, scene:_scene, camera:_camera, viewport:_viewport, lookAt:_lookAtTarget};
        }// end function

        protected function matrixWrite(param1, param2:int, param3:Array) : Number
        {
            return _startMatrix[param2] + _changeMatrix[param2] * _position;
        }// end function

        protected function matrixSubtraction(param1, param2:int, param3:Array) : Number
        {
            return param1 - _startMatrix[param2];
        }// end function

        public static function init() : void
        {
            if (_init)
            {
                return;
            }
            _init = true;
            debug = trace;
            if (!GoEngine.getManager("OverlapMonitor"))
            {
                GoEngine.addManager(new OverlapMonitor());
            }
            if (VERBOSE)
            {
                debug("\n\t*****************************\n\tVERSION: " + VERSION + " - Go Version: " + GoEngine.INFO + "\n\t*****************************\n\n");
            }
            _propertyList["x"] = {prop:"x", read:genericRead, write:genericWrite};
            _propertyList["y"] = {prop:"y", read:genericRead, write:genericWrite};
            _propertyList["scaleX"] = {prop:"scaleX", read:genericRead, write:genericWrite};
            _propertyList["scaleY"] = {prop:"scaleY", read:genericRead, write:genericWrite};
            _propertyList["width"] = {prop:"width", read:genericRead, write:genericWrite};
            _propertyList["height"] = {prop:"height", read:genericRead, write:genericWrite};
            _propertyList["rotation"] = {prop:"rotation", read:genericRead, write:genericWrite};
            _propertyList["alpha"] = {prop:"alpha", read:genericRead, write:genericWrite};
            _propertyList["frame"] = {prop:"currentFrame", read:frameRead, write:frameWrite};
            _propertyList["Bevel_angle"] = {prop:"angle", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_blurX"] = {prop:"blurX", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_blurY"] = {prop:"blurY", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_color"] = {prop:"color", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_distance"] = {prop:"distance", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_highlightAlpha"] = {prop:"highlightAlpha", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_highlightColor"] = {prop:"highlightColor", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_quality"] = {prop:"quality", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_shadowAlpha"] = {prop:"shadowAlpha", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_shadowColor"] = {prop:"shadowColor", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Bevel_strength"] = {prop:"strength", definition:BevelFilter, read:filterRead, write:filterWrite};
            _propertyList["Blur_blurX"] = {prop:"blurX", definition:BlurFilter, read:filterRead, write:filterWrite};
            _propertyList["Blur_blurY"] = {prop:"blurY", definition:BlurFilter, read:filterRead, write:filterWrite};
            _propertyList["Blur_quality"] = {prop:"quality", definition:BlurFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_alpha"] = {prop:"alpha", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_angle"] = {prop:"angle", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_blurX"] = {prop:"blurX", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_blurY"] = {prop:"blurY", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_color"] = {prop:"color", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_distance"] = {prop:"distance", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_quality"] = {prop:"quality", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["DropShadow_strength"] = {prop:"strength", definition:DropShadowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_alpha"] = {prop:"alpha", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_blurX"] = {prop:"blurX", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_blurY"] = {prop:"blurY", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_color"] = {prop:"color", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_quality"] = {prop:"quality", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["Glow_strength"] = {prop:"strength", definition:GlowFilter, read:filterRead, write:filterWrite};
            _propertyList["matrix"] = {prop:"matrix", definition:ColorMatrixFilter, read:filterRead, write:filterWrite, adjust:adjustMatrix};
            _propertyList["brightness"] = {prop:"matrix", definition:ColorMatrixFilter, read:filterRead, write:filterWrite, adjust:adjustBrightness};
            _propertyList["contrast"] = {prop:"matrix", definition:ColorMatrixFilter, read:filterRead, write:filterWrite, adjust:adjustContrast};
            _propertyList["saturation"] = {prop:"matrix", definition:ColorMatrixFilter, read:filterRead, write:filterWrite, adjust:adjustSaturation};
            _propertyList["hue"] = {prop:"matrix", definition:ColorMatrixFilter, read:filterRead, write:filterWrite, adjust:adjustHue};
            _propertyList["color"] = {prop:"color", read:colorRead, write:colorWrite};
            _propertyList["volume"] = {prop:"volume", read:transformRead, write:transformWrite, path:"soundTransform"};
            _propertyList["pan"] = {prop:"pan", read:transformRead, write:transformWrite, path:"soundTransform"};
            _propertyList["text"] = {prop:"text", read:textRead, write:textWrite, path:"text"};
            _propertyList["z"] = {prop:"z", read:genericRead, write:genericWrite};
            _propertyList["rotationX"] = {prop:"rotationX", read:genericRead, write:genericWrite};
            _propertyList["rotationY"] = {prop:"rotationY", read:genericRead, write:genericWrite};
            _propertyList["rotationZ"] = {prop:"rotationZ", read:genericRead, write:genericWrite};
            _propertyList["scale"] = {prop:"scale", read:genericRead, write:genericWrite};
            _propertyList["scaleX"] = {prop:"scaleX", read:genericRead, write:genericWrite};
            _propertyList["scaleY"] = {prop:"scaleY", read:genericRead, write:genericWrite};
            _propertyList["scaleZ"] = {prop:"scaleZ", read:genericRead, write:genericWrite};
            _propertyList["sceneX"] = {prop:"sceneX", read:genericRead, write:genericWrite};
            _propertyList["sceneY"] = {prop:"sceneY", read:genericRead, write:genericWrite};
            _propertyList["sceneZ"] = {prop:"sceneZ", read:genericRead, write:genericWrite};
            _propertyList["scale"] = {prop:"scale", read:genericRead, write:genericWrite};
            _propertyList["tilt"] = {prop:"tilt", read:genericRead, write:genericWrite};
            _propertyList["pitch"] = {prop:"pitch", read:genericRead, write:genericWrite};
            _propertyList["yaw"] = {prop:"yaw", read:genericRead, write:genericWrite};
            _propertyList["roll"] = {prop:"roll", read:genericRead, write:genericWrite};
            _propertyList["flameHeight"] = {prop:"flameHeight", read:genericRead, write:genericWrite};
            _propertyList["flameSpread"] = {prop:"flameSpread", read:genericRead, write:genericWrite};
            _propertyList["charPosition"] = {prop:"charPosition", read:genericMakeRead, write:genericMakeWrite};
            _propertyList["position"] = {prop:"position", read:genericMakeRead, write:genericMakeWrite};
            _propertyList["speed"] = {prop:"speed", read:genericMakeRead, write:genericMakeWrite};
            _propertyList["val"] = {prop:"val", read:genericRead, write:genericWrite};
            return;
        }// end function

        public static function init3D(param1, param2, param3, param4, param5 = null) : void
        {
            if (!GoEngine.getManager("RenderManager"))
            {
                GoEngine.addManager(new PV3DRenderManager());
            }
            _renderer = param1;
            _scene = param2;
            _camera = param3;
            _viewport = param4;
            _init3D = true;
            _lookAtTarget = param5;
            return;
        }// end function

        public static function addProperty(param1:String) : void
        {
            if (!_propertyList.hasOwnProperty(param1))
            {
                _propertyList[param1] = {prop:param1, read:genericRead, write:genericWrite};
            }
            return;
        }// end function

        public static function setPulse(param1:Number) : void
        {
            PULSE = param1;
            return;
        }// end function

        public static function go(param1:Object, param2:Object = null, param3:Number = NaN, param4:Number = NaN, param5:Function = null, param6:Function = null, param7:Function = null, param8:Array = null, param9:Array = null, param10:Array = null, param11:Object = null, param12:Boolean = false, param13:Boolean = false, param14:Number = -1) : IPlayable
        {
            var _loc_19:Object = null;
            var _loc_20:HydroTween = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_15:* = param1 is Array;
            var _loc_16:* = param1 is Array ? (new PlayableGroup()) : (null);
            var _loc_17:* = _loc_15 ? (param1 as Array) : ([param1]);
            var _loc_18:int = 0;
            for each (_loc_19 in _loc_17)
            {
                
                _loc_20 = new HydroTween(_loc_19, param2, param3, param4, param5, _loc_18 == (_loc_17.length - 1) ? (param6) : (null), _loc_18 == (_loc_17.length - 1) ? (param7) : (null), _loc_18 == (_loc_17.length - 1) ? (param8) : (null), _loc_18 == (_loc_17.length - 1) ? (param9) : (null), param10, param11, param12, param13, HydroTween.PULSE);
                if (_loc_15)
                {
                    (_loc_16 as PlayableGroup).addChild(_loc_20);
                }
                else
                {
                    _loc_16 = _loc_20;
                }
                _loc_18++;
            }
            _loc_16.start();
            return _loc_16;
        }// end function

        public static function parseSequence(... args) : void
        {
            if (VERBOSE)
            {
                debug("Use HydroSequence!");
            }
            return;
        }// end function

        public static function sequence(... args) : void
        {
            if (VERBOSE)
            {
                debug("Use HydroSequence!");
            }
            return;
        }// end function

        static function getFilterDefaults() : Array
        {
            var _loc_1:* = new Array();
            _loc_1[BevelFilter] = new BevelFilter(0, 45, 16711680, 1, 255, 1, 4, 4, 1, 2, "inner", false);
            _loc_1[BlurFilter] = new BlurFilter(0, 0, 2);
            _loc_1[DropShadowFilter] = new DropShadowFilter(0, 45, 0, 1, 8, 8, 0, 2, false, false, false);
            _loc_1[GlowFilter] = new GlowFilter(16711680, 1, 0, 0, 2, 2, false, false);
            _loc_1[ColorMatrixFilter] = new ColorMatrixFilter(IDENTITY);
            return _loc_1;
        }// end function

        public static function getVersion() : String
        {
            return VERSION;
        }// end function

        public static function getPropertyList() : void
        {
            var _loc_1:String = null;
            for (_loc_1 in _propertyList)
            {
                
                if (VERBOSE)
                {
                    debug(_loc_1);
                }
            }
            return;
        }// end function

        static function genericRead(param1:Object, param2:String) : Number
        {
            return param1[_propertyList[param2].prop];
        }// end function

        static function genericWrite(param1:Object, param2:String, param3:Number, param4:Number = 0) : void
        {
            param1[_propertyList[param2].prop] = param3;
            return;
        }// end function

        static function frameRead(param1:Object, param2:String) : Number
        {
            return param1[_propertyList[param2].prop];
        }// end function

        static function frameWrite(param1:Object, param2:String, param3:Number, param4:Number = 0) : void
        {
            param1.gotoAndStop(int(param3));
            return;
        }// end function

        static function cmRead(param1:Object)
        {
            var _loc_2:BitmapFilter = null;
            if (!(param1 is DisplayObject))
            {
                return;
            }
            var _loc_3:* = param1.filters;
            var _loc_4:int = 0;
            while (_loc_4 < param1.filters.length)
            {
                
                if (_loc_3[_loc_4] is ColorMatrixFilter)
                {
                    return param1.filters[_loc_4]["matrix"];
                }
                _loc_4++;
            }
            _loc_2 = getFilterDefaults()[ColorMatrixFilter];
            return _loc_2["matrix"];
        }// end function

        static function filterRead(param1:Object, param2:String)
        {
            var _loc_3:BitmapFilter = null;
            var _loc_4:* = param1.filters;
            var _loc_5:int = 0;
            while (_loc_5 < param1.filters.length)
            {
                
                if (_loc_4[_loc_5] is _propertyList[param2].definition)
                {
                    if (_propertyList[param2].prop != "color" && _propertyList[param2].prop != "highlightColor" && _propertyList[param2].prop != "shadowColor")
                    {
                        return param1.filters[_loc_5][_propertyList[param2].prop];
                    }
                }
                _loc_5++;
            }
            _loc_3 = getFilterDefaults()[_propertyList[param2].definition];
            return _loc_3[_propertyList[param2].prop];
        }// end function

        static function filterWrite(param1:Object, param2:String, param3, param4 = 0) : void
        {
            var _loc_6:BitmapFilter = null;
            var _loc_5:* = param1.filters;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_5.length)
            {
                
                if (_loc_5[_loc_7] is _propertyList[param2].definition)
                {
                    _loc_5[_loc_7][_propertyList[param2].prop] = _propertyList[param2].prop != "color" && _propertyList[param2].prop != "highlightColor" && _propertyList[param2].prop != "shadowColor" ? (param3) : (param4);
                    param1.filters = _loc_5;
                    return;
                }
                _loc_7++;
            }
            if (_loc_5 == null)
            {
                _loc_5 = new Array();
            }
            _loc_6 = getFilterDefaults()[_propertyList[param2].definition];
            _loc_6[_propertyList[param2].prop] = param3;
            _loc_5.push(_loc_6);
            param1.filters = _loc_5;
            return;
        }// end function

        public static function adjustMatrix(param1:Array, param2:Array) : Array
        {
            return multiplyMatrix(param1, param2);
        }// end function

        static function colorRead(param1:Object, param2:String, param3:Dictionary) : ColorTransform
        {
            return param1.transform.colorTransform;
        }// end function

        static function colorWrite(param1:Object, param2:String, param3:Number, param4:ColorTransform, param5, param6:Dictionary) : void
        {
            var _loc_7:* = param3;
            var _loc_8:* = 1 - _loc_7;
            var _loc_9:* = new ColorTransform();
            if (param5 != IDENTITY)
            {
                _loc_9.color = param5;
            }
            if (param6["alpha"] != null)
            {
                _loc_9.alphaMultiplier = param6["alpha"].end;
            }
            else
            {
                _loc_9.alphaMultiplier = param1.alpha;
            }
            param1.transform.colorTransform = new ColorTransform(param4.redMultiplier * _loc_8 + _loc_9.redMultiplier * _loc_7, param4.greenMultiplier * _loc_8 + _loc_9.greenMultiplier * _loc_7, param4.blueMultiplier * _loc_8 + _loc_9.blueMultiplier * _loc_7, param4.alphaMultiplier * _loc_8 + _loc_9.alphaMultiplier * _loc_7, param4.redOffset * _loc_8 + _loc_9.redOffset * _loc_7, param4.greenOffset * _loc_8 + _loc_9.greenOffset * _loc_7, param4.blueOffset * _loc_8 + _loc_9.blueOffset * _loc_7, param4.alphaOffset * _loc_8 + _loc_9.alphaOffset * _loc_7);
            return;
        }// end function

        static function adjustBrightness(param1:Array, param2:Number) : Array
        {
            param2 = cleanValue(param2, 10) * 100;
            if (param2 == 0 || isNaN(param2))
            {
                return param1;
            }
            return multiplyMatrix(param1, [1, 0, 0, 0, param2, 0, 1, 0, 0, param2, 0, 0, 1, 0, param2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }// end function

        static function adjustContrast(param1:Array, param2:Number) : Array
        {
            var _loc_3:Number = NaN;
            param2 = cleanValue(param2, 1) * 100;
            if (param2 == 0 || isNaN(param2))
            {
                return param1;
            }
            if (param2 < 0)
            {
                _loc_3 = 127 + param2 / 100 * 127;
            }
            else
            {
                _loc_3 = param2 % 1;
                if (_loc_3 == 0)
                {
                    _loc_3 = DELTA_INDEX[param2];
                }
                else
                {
                    _loc_3 = DELTA_INDEX[param2 << 0] * (1 - _loc_3) + DELTA_INDEX[(param2 << 0) + 1] * _loc_3;
                }
                _loc_3 = _loc_3 * 127 + 127;
            }
            return multiplyMatrix(param1, [_loc_3 / 127, 0, 0, 0, 0.5 * (127 - _loc_3), 0, _loc_3 / 127, 0, 0, 0.5 * (127 - _loc_3), 0, 0, _loc_3 / 127, 0, 0.5 * (127 - _loc_3), 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }// end function

        static function adjustSaturation(param1:Array, param2:Number) : Array
        {
            param2 = cleanValue(param2, 10) * 100;
            if (param2 == 0 || isNaN(param2))
            {
                return param1;
            }
            var _loc_3:* = 1 + (param2 > 0 ? (3 * param2 / 100) : (param2 / 100));
            var _loc_4:Number = 0.3086;
            var _loc_5:Number = 0.6094;
            var _loc_6:Number = 0.082;
            return multiplyMatrix(param1, [_loc_4 * (1 - _loc_3) + _loc_3, _loc_5 * (1 - _loc_3), _loc_6 * (1 - _loc_3), 0, 0, _loc_4 * (1 - _loc_3), _loc_5 * (1 - _loc_3) + _loc_3, _loc_6 * (1 - _loc_3), 0, 0, _loc_4 * (1 - _loc_3), _loc_5 * (1 - _loc_3), _loc_6 * (1 - _loc_3) + _loc_3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }// end function

        static function adjustHue(param1:Array, param2:Number) : Array
        {
            param2 = cleanValue(param2, 180) / 180 * Math.PI;
            if (param2 == 0 || isNaN(param2))
            {
                return param1;
            }
            var _loc_3:* = Math.cos(param2);
            var _loc_4:* = Math.sin(param2);
            return multiplyMatrix(param1, [_r_lum + _loc_3 * (1 - _r_lum) + _loc_4 * (-_r_lum), _g_lum + _loc_3 * (-_g_lum) + _loc_4 * (-_g_lum), _b_lum + _loc_3 * (-_b_lum) + _loc_4 * (1 - _b_lum), 0, 0, _r_lum + _loc_3 * (-_r_lum) + _loc_4 * 0.143, _g_lum + _loc_3 * (1 - _g_lum) + _loc_4 * 0.14, _b_lum + _loc_3 * (-_b_lum) + _loc_4 * -0.283, 0, 0, _r_lum + _loc_3 * (-_r_lum) + _loc_4 * (-(1 - _r_lum)), _g_lum + _loc_3 * (-_g_lum) + _loc_4 * _g_lum, _b_lum + _loc_3 * (1 - _b_lum) + _loc_4 * _b_lum, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
        }// end function

        static function multiplyMatrix(param1:Array, param2:Array) : Array
        {
            var _loc_6:int = 0;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_3:Array = [];
            var _loc_4:Array = [];
            var _loc_5:int = 0;
            while (_loc_5 < 5)
            {
                
                _loc_6 = 0;
                while (_loc_6 < 5)
                {
                    
                    _loc_3[_loc_6] = param1[_loc_6 + _loc_5 * 5];
                    _loc_6++;
                }
                _loc_6 = 0;
                while (_loc_6 < 5)
                {
                    
                    _loc_7 = 0;
                    _loc_8 = 0;
                    while (_loc_8 < 5)
                    {
                        
                        _loc_7 = _loc_7 + param2[_loc_6 + _loc_8 * 5] * _loc_3[_loc_8];
                        _loc_8 = _loc_8 + 1;
                    }
                    _loc_4[_loc_6 + _loc_5 * 5] = _loc_7;
                    _loc_6++;
                }
                _loc_5++;
            }
            return _loc_4;
        }// end function

        static function cleanValue(param1:Number, param2:Number) : Number
        {
            return Math.min(param2, Math.max(-param2, param1));
        }// end function

        static function fixMatrix(param1:Array = null) : Array
        {
            if (param1 == null)
            {
                return IDENTITY;
            }
            if (param1 is Array)
            {
                param1 = param1.slice(0);
            }
            if (param1.length < IDENTITY.length)
            {
                param1 = param1.slice(0, param1.length).concat(IDENTITY.slice(param1.length, IDENTITY.length));
            }
            else if (param1.length > IDENTITY.length)
            {
                param1 = param1.slice(0, IDENTITY.length);
            }
            return param1;
        }// end function

        static function transformRead(param1:Object, param2:String) : Number
        {
            return param1[_propertyList[param2].path][_propertyList[param2].prop];
        }// end function

        static function transformWrite(param1:Object, param2:String, param3:Number, param4:Number = 0) : void
        {
            var _loc_5:* = param1[_propertyList[param2].path];
            param1[_propertyList[param2].path][_propertyList[param2].prop] = param3;
            param1[_propertyList[param2].path] = _loc_5;
            return;
        }// end function

        static function textRead(param1:Object, param2:String) : Number
        {
            return new Number(param1[_propertyList[param2].path]);
        }// end function

        static function textWrite(param1:Object, param2:String, param3:Number, param4:Number = 0) : void
        {
            param1[_propertyList[param2].path] = int(param3).toString();
            return;
        }// end function

        static function genericMakeRead(param1:Object, param2:String) : Number
        {
            return param1[_propertyList[param2].prop];
        }// end function

        static function genericMakeWrite(param1:Object, param2:String, param3:Number, param4:Number = 0) : void
        {
            param1[_propertyList[param2].prop] = Math.round(param3);
            param1.update();
            return;
        }// end function

    }
}
