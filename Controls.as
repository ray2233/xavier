package 
{
    import flash.display.*;
    import flash.events.*;

    public class Controls extends MovieClip
    {
        public const EMO_DURATION_SEC:Number = 2;
        private const WATCH_URL:String = "http://www.sitepal.com/overviewmovie";
        private const UPLOAD_URL:String = "http://vhss-d.oddcast.com/admin/sitepalV5.php";
        public var btn_stop:SimpleButton;
        public var emo_art:MovieClip;
        public var btn_1:SimpleButton;
        public var btn_mute:SimpleButton;
        public var btn_watch:SimpleButton;
        public var btn_catalogue:SimpleButton;
        public var btn_emo_1:MovieClip;
        public var btn_emo_2:MovieClip;
        public var btn_emo_3:MovieClip;
        public var btn_emo_4:MovieClip;
        public var btn_play:SimpleButton;
        public var btn_upload:SimpleButton;
        public var mute_art:MovieClip;
        public var highlight_1:MovieClip;
        public var highlight_2:MovieClip;
        public var highlight_3:MovieClip;
        public var highlight_4:MovieClip;
        public var highlight_5:MovieClip;
        public var upload_popup:MovieClip;
        public var mc_3d1:MovieClip;
        public var mc_3d2:MovieClip;
        public var mc_2d1:MovieClip;
        public var mc_2d2:MovieClip;
        var cur_scene_highlighted:String;

        public function Controls()
        {
            emo_art.mouseEnabled = false;
            var _loc_1:int = 1;
            while (_loc_1 < 5)
            {
                
                (this["btn_emo_" + _loc_1] as MovieClip).addEventListener(MouseEvent.CLICK, btn_emo_toggle);
                (this["btn_emo_" + _loc_1] as MovieClip).buttonMode = true;
                _loc_1++;
            }
            init_upload_popup();
            btn_emo_toggle();
            highlight("btn_1");
            visible = false;
            mute_art.mouseEnabled = false;
            mute_art.stop();
            btn_upload.addEventListener(MouseEvent.CLICK, hyperlinks_handler);
            btn_watch.addEventListener(MouseEvent.CLICK, hyperlinks_handler);
            btn_catalogue.addEventListener(MouseEvent.CLICK, hyperlinks_handler);
            btn_1.addEventListener(MouseEvent.CLICK, scene_selected);
            mc_3d1.addEventListener(MouseEvent.CLICK, scene_selected);
            mc_3d2.addEventListener(MouseEvent.CLICK, scene_selected);
            mc_2d1.addEventListener(MouseEvent.CLICK, scene_selected);
            mc_2d2.addEventListener(MouseEvent.CLICK, scene_selected);
            mc_3d1.addEventListener(MouseEvent.ROLL_OVER, highlight_over_out);
            mc_3d2.addEventListener(MouseEvent.ROLL_OVER, highlight_over_out);
            mc_2d1.addEventListener(MouseEvent.ROLL_OVER, highlight_over_out);
            mc_2d2.addEventListener(MouseEvent.ROLL_OVER, highlight_over_out);
            mc_3d1.addEventListener(MouseEvent.ROLL_OUT, highlight_over_out);
            mc_3d2.addEventListener(MouseEvent.ROLL_OUT, highlight_over_out);
            mc_2d1.addEventListener(MouseEvent.ROLL_OUT, highlight_over_out);
            mc_2d2.addEventListener(MouseEvent.ROLL_OUT, highlight_over_out);
            return;
        }// end function

        public function toggle_emotions(param1:String) : void
        {
            if (param1 == "btn_1" || param1 == "mc_3d1" || param1 == "mc_3d2")
            {
                var _loc_2:Boolean = true;
                btn_emo_4.visible = true;
                var _loc_2:* = _loc_2;
                btn_emo_3.visible = _loc_2;
                var _loc_2:* = _loc_2;
                btn_emo_2.visible = _loc_2;
                var _loc_2:* = _loc_2;
                btn_emo_1.visible = _loc_2;
                emo_art.visible = _loc_2;
            }
            else
            {
                var _loc_2:Boolean = false;
                btn_emo_4.visible = false;
                var _loc_2:* = _loc_2;
                btn_emo_3.visible = _loc_2;
                var _loc_2:* = _loc_2;
                btn_emo_2.visible = _loc_2;
                var _loc_2:* = _loc_2;
                btn_emo_1.visible = _loc_2;
                emo_art.visible = _loc_2;
            }
            return;
        }// end function

        private function hyperlinks_handler(event:MouseEvent) : void
        {
            switch(event.target)
            {
                case btn_watch:
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call("window.open", WATCH_URL, "popupoverview", "menubar=no,width=700,height=400,toolbar=no,scrollbars=yes");
                    }
                    else
                    {
                        navigateToURL(new URLRequest(WATCH_URL));
                    }
                    break;
                }
                case btn_catalogue:
                {
                    if (ExternalInterface.available)
                    {
                        ExternalInterface.call("window.open", "http://vhost.oddcast.com/gallery/gallery.php?type=model");
                    }
                    else
                    {
                        navigateToURL(new URLRequest("http://vhost.oddcast.com/gallery/gallery.php?type=model"), "_blank");
                    }
                    break;
                }
                case btn_upload:
                {
                    open_upload_popup();
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function btn_emo_toggle(event:MouseEvent = null) : void
        {
            var reset_btns:Function;
            var event:* = event;
            var i:int;
            var _e:* = event;
            while (i < 5)
            {
                
                (this["btn_emo_" + i] as MovieClip).gotoAndStop(1);
                i = (i + 1);
            }
            if (_e)
            {
                reset_btns = function () : void
            {
                btn_emo_toggle();
                return;
            }// end function
            ;
                (_e.target as MovieClip).gotoAndStop(2);
                setTimeout(reset_btns, EMO_DURATION_SEC * 1000);
            }
            return;
        }// end function

        private function highlight_over_out(event:MouseEvent) : void
        {
            trace("Controls::highlight_over_out " + event.currentTarget.name + " " + event.type);
            if (event.type == "rollOut")
            {
                if (event.currentTarget.name != cur_scene_highlighted)
                {
                    trace("Controls::highlight_over_out HIDE" + event.type);
                    if (event.currentTarget.name == "btn_1")
                    {
                        this["highlight_1"].gotoAndStop(1);
                    }
                    if (event.currentTarget.name == "mc_3d1")
                    {
                        this["highlight_2"].gotoAndStop(1);
                    }
                    if (event.currentTarget.name == "mc_3d2")
                    {
                        this["highlight_3"].gotoAndStop(1);
                    }
                    if (event.currentTarget.name == "mc_2d1")
                    {
                        this["highlight_4"].gotoAndStop(1);
                    }
                    if (event.currentTarget.name == "mc_2d2")
                    {
                        this["highlight_5"].gotoAndStop(1);
                    }
                }
            }
            else if (event.type == "rollOver")
            {
                if (event.currentTarget.name != cur_scene_highlighted)
                {
                    if (event.currentTarget.name == "btn_1")
                    {
                        this["highlight_1"].gotoAndStop(2);
                    }
                    if (event.currentTarget.name == "mc_3d1")
                    {
                        this["highlight_2"].gotoAndStop(2);
                    }
                    if (event.currentTarget.name == "mc_3d2")
                    {
                        this["highlight_3"].gotoAndStop(2);
                    }
                    if (event.currentTarget.name == "mc_2d1")
                    {
                        this["highlight_4"].gotoAndStop(2);
                    }
                    if (event.currentTarget.name == "mc_2d2")
                    {
                        this["highlight_5"].gotoAndStop(2);
                    }
                }
            }
            return;
        }// end function

        private function highlight(param1:String) : void
        {
            trace("highlight " + param1 + " , " + cur_scene_highlighted);
            if (param1 == cur_scene_highlighted)
            {
                trace("skipped");
            }
            else
            {
                trace("Controls::highlight_over_out SHOW " + param1 + " ");
                if (param1 == "btn_1")
                {
                    this["highlight_1"].gotoAndStop(2);
                }
                else
                {
                    this["highlight_1"].gotoAndStop(1);
                }
                if (param1 == "mc_3d1")
                {
                    this["highlight_2"].gotoAndStop(2);
                }
                else
                {
                    this["highlight_2"].gotoAndStop(1);
                }
                if (param1 == "mc_3d2")
                {
                    this["highlight_3"].gotoAndStop(2);
                }
                else
                {
                    this["highlight_3"].gotoAndStop(1);
                }
                if (param1 == "mc_2d1")
                {
                    this["highlight_4"].gotoAndStop(2);
                }
                else
                {
                    this["highlight_4"].gotoAndStop(1);
                }
                if (param1 == "mc_2d2")
                {
                    this["highlight_5"].gotoAndStop(2);
                }
                else
                {
                    this["highlight_5"].gotoAndStop(1);
                }
            }
            cur_scene_highlighted = param1;
            return;
        }// end function

        private function init_upload_popup() : void
        {
            close_upload_popup();
            return;
        }// end function

        private function open_upload_popup() : void
        {
            var delay_add_close:Function;
            delay_add_close = function () : void
            {
                stage.addEventListener(MouseEvent.CLICK, close_upload_popup);
                return;
            }// end function
            ;
            upload_popup.visible = true;
            upload_popup.alpha = 0;
            HydroTween.go(upload_popup, {alpha:1}, 0.5);
            setTimeout(delay_add_close, 50);
            upload_popup.icons.anim1.alpha = 0;
            upload_popup.icons.anim2.alpha = 0;
            upload_popup.icons.anim3.alpha = 0;
            upload_popup.icons.anim4.alpha = 0;
            upload_popup.icons.anim5.alpha = 0;
            HydroTween.go(upload_popup.icons.anim1, {alpha:1}, 0.5, 0.5);
            HydroTween.go(upload_popup.icons.anim2, {alpha:1}, 0.5, 1);
            HydroTween.go(upload_popup.icons.anim3, {alpha:1}, 0.5, 1.5);
            HydroTween.go(upload_popup.icons.anim4, {alpha:1}, 0.5, 2);
            HydroTween.go(upload_popup.icons.anim5, {alpha:1}, 0.5, 2.5);
            return;
        }// end function

        private function close_upload_popup(event:MouseEvent = null) : void
        {
            var kill_popup:Function;
            var event:* = event;
            var _e:* = event;
            kill_popup = function () : void
            {
                upload_popup.visible = false;
                return;
            }// end function
            ;
            stage.removeEventListener(MouseEvent.CLICK, close_upload_popup);
            HydroTween.go(upload_popup, {alpha:0}, 0.5, 0, null, kill_popup);
            return;
        }// end function

        private function scene_selected(event:MouseEvent) : void
        {
            var _loc_2:String = null;
            trace("Controls::scene_selected " + event.currentTarget.name);
            if (event.currentTarget.name.search("mc_") != -1)
            {
                trace("Controls::scene_selected ***");
                _loc_2 = event.currentTarget.name;
            }
            else
            {
                trace("Controls::scene_selected *-*");
                _loc_2 = event.currentTarget.name;
            }
            highlight(_loc_2);
            return;
        }// end function

    }
}
