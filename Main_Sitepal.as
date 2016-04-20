package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.ui.*;

    public class Main_Sitepal extends MovieClip
    {
        private var show_api:Object;
        private const SHOW_URL:String = "http://content.oddcast.com/vhss/vhss_v5.swf?doc=http%3A%2F%2Fvhss-d.oddcast.com%2Fphp%2FplayScene%2Facc%3D237929%2Fss%3D1889868%2Fsl%3D0&acc=237929&bgcolor=0x&embedid=ed6c3c8d55e75a5595a8b96853087821";
        private var is_muted:Boolean = false;
        public var show_holder:Show_Holder;
        private var so_convo:SO_Convo;
        public var main_loader:MovieClip;
        private var audio_logic:Audio_Logic;
        private var play_intro_audios:Boolean = true;
        public var controls:Controls;
        private const TEST_AUDIO_URL:String = "http://content.oddcast.com/ccs2/vhss/user/eb3/237929/audio/1227674384231_237929.mp3";
        private var cur_scene_index:int = 1;
        private const COMPILATION_TIME:String = "v0910221638";
        private var cur_slide:int = 2;
        private const ANIMATION_INTENSITY:int = 100;
        public var uyp:MovieClip;
        public var txt:MovieClip;
        var avatar_list_3d:Array;
        var avatar_list_2d:Array;
        var selected_btn_3d1:Number;
        var selected_btn_3d2:Number;
        var selected_btn_3d1_gender:String;
        var selected_btn_3d2_gender:String;
        var selected_btn_2d1:Number;
        var selected_btn_2d2:Number;
        var selected_btn_2d1_gender:String;
        var selected_btn_2d2_gender:String;

        public function Main_Sitepal()
        {
            select_random_avatars();
            uyp.alpha = 0;
            txt.alpha = 0;
            cur_slide = 2;
            is_muted = false;
            so_convo = new SO_Convo();
            audio_logic = new Audio_Logic();
            cur_scene_index = 1;
            play_intro_audios = true;
            so_convo.init();
            load_show(show_ready);
            prepare_controls();
            toggle_main_loader(true);
            prep_right_click_menu(this);
            audio_logic.init(so_convo.num_of_user_visits);
            return;
        }// end function

        public function select_random_avatars()
        {
            avatar_list_3d = new Array("Brandon:male", "Heather:female", "Jack:male", "James:male", "Kara:female", "Laura:female", "Liz:female", "Melissa:female", "Neil:male", "Raymond:male");
            avatar_list_2d = new Array("Annabelle:female", "Brenda:female", "Dana:female", "Dylan:male", "Huny:male", "Jesse:male", "Lisa:female", "Pete:male", "Rachel:female", "Victor:male");
            selected_btn_3d1 = Math.round(Math.random() * (avatar_list_3d.length - 1));
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_3d1);
            selected_btn_3d1_gender = avatar_list_3d[selected_btn_3d1].split(":")[1];
            selected_btn_3d2 = Math.round(Math.random() * (avatar_list_3d.length - 1));
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_3d2);
            selected_btn_3d2_gender = avatar_list_3d[selected_btn_3d2].split(":")[1];
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_3d1 + "==" + selected_btn_3d2 + " , " + selected_btn_3d1_gender + "==" + selected_btn_3d2_gender);
            while (selected_btn_3d1 == selected_btn_3d2 || selected_btn_3d1_gender == selected_btn_3d2_gender)
            {
                
                selected_btn_3d2 = Math.ceil(Math.random() * (avatar_list_3d.length - 1));
                selected_btn_3d2_gender = avatar_list_3d[selected_btn_3d2].split(":")[1];
                trace("Main_Sitepal::select_random_avatars * " + selected_btn_3d1 + "==" + selected_btn_3d2 + " , " + selected_btn_3d1_gender + "==" + selected_btn_3d2_gender);
            }
            trace("Main_Sitepal::select_random_avatars - 3d1 picked \'" + selected_btn_3d1 + "\' , \'" + avatar_list_3d[selected_btn_3d1].split(":")[0] + "\' , \'" + selected_btn_3d1_gender + "\'");
            trace("Main_Sitepal::select_random_avatars - 3d2 picked \'" + selected_btn_3d2 + "\' , \'" + avatar_list_3d[selected_btn_3d2].split(":")[0] + "\' , \'" + selected_btn_3d2_gender + "\'");
            controls.mc_3d1.gotoAndStop((selected_btn_3d1 + 1));
            controls.mc_3d2.gotoAndStop((selected_btn_3d2 + 1));
            selected_btn_3d1 = Number(selected_btn_3d1) + 6;
            selected_btn_3d2 = Number(selected_btn_3d2) + 6;
            selected_btn_2d1 = Math.ceil(Math.random() * (avatar_list_2d.length - 1));
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_2d1);
            selected_btn_2d1_gender = avatar_list_2d[selected_btn_2d1].split(":")[1];
            selected_btn_2d2 = Math.ceil(Math.random() * (avatar_list_2d.length - 1));
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_2d2);
            selected_btn_2d2_gender = avatar_list_2d[selected_btn_2d2].split(":")[1];
            trace("Main_Sitepal::select_random_avatars - " + selected_btn_2d1 + "==" + selected_btn_2d2 + " , " + selected_btn_2d1_gender + "==" + selected_btn_2d2_gender);
            while (selected_btn_2d1 == selected_btn_2d2 || selected_btn_2d1_gender == selected_btn_2d2_gender)
            {
                
                selected_btn_2d2 = Math.ceil(Math.random() * (avatar_list_2d.length - 1));
                selected_btn_2d2_gender = avatar_list_2d[selected_btn_2d2].split(":")[1];
                trace("Main_Sitepal::select_random_avatars * " + selected_btn_2d1 + "==" + selected_btn_2d2 + " , " + selected_btn_2d1_gender + "==" + selected_btn_2d2_gender);
            }
            trace("Main_Sitepal::select_random_avatars - 2d1 picked \'" + selected_btn_2d1 + "\' , \'" + avatar_list_2d[selected_btn_2d1].split(":")[0] + "\' , \'" + selected_btn_2d1_gender + "\'");
            trace("Main_Sitepal::select_random_avatars - 2d2 picked \'" + selected_btn_2d2 + "\' , \'" + avatar_list_2d[selected_btn_2d2].split(":")[0] + "\' , \'" + selected_btn_2d2_gender + "\'");
            controls.mc_2d1.gotoAndStop((selected_btn_2d1 + 1));
            controls.mc_2d2.gotoAndStop((selected_btn_2d2 + 1));
            selected_btn_2d1 = Number(selected_btn_2d1) + 16;
            selected_btn_2d2 = Number(selected_btn_2d2) + 16;
            return;
        }// end function

        private function allow_external_calls() : void
        {
            try
            {
                ExternalInterface.addCallback("sayAudio", javascript_sayAudio);
                ExternalInterface.addCallback("stopSpeech", javascript_stopSpeech);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function speak_audio(param1:String) : void
        {
            stop_audio();
            show_api.sayAudio(param1);
            so_convo.audio_spoken();
            return;
        }// end function

        private function toggle_mute(param1:Boolean) : void
        {
            var _loc_2:SoundTransform = null;
            is_muted = param1;
            _loc_2 = new SoundTransform();
            _loc_2.volume = param1 ? (0) : (1);
            SoundMixer.soundTransform = _loc_2;
            so_convo.save_mute(param1);
            controls.mute_art.gotoAndStop(param1 ? (2) : (1));
            return;
        }// end function

        private function javascript_sayAudio(param1:String) : void
        {
            speak_audio(param1);
            return;
        }// end function

        private function prep_right_click_menu(param1:MovieClip) : void
        {
            var myMenu:ContextMenu;
            var menuItem1:ContextMenuItem;
            var goto_oddcast:Function;
            var param1:* = param1;
            var _target:* = param1;
            goto_oddcast = function () : void
            {
                navigateToURL(new URLRequest("http://www.oddcast.com"));
                return;
            }// end function
            ;
            myMenu = new ContextMenu();
            myMenu.hideBuiltInItems();
            menuItem1 = new ContextMenuItem("Powered By Oddcast");
            menuItem1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goto_oddcast);
            myMenu.customItems.push(menuItem1);
            myMenu.customItems.push(new ContextMenuItem(COMPILATION_TIME));
            _target.contextMenu = myMenu;
            return;
        }// end function

        private function javascript_stopSpeech() : void
        {
            stop_audio();
            return;
        }// end function

        private function stop_audio() : void
        {
            show_api.stopSpeech();
            return;
        }// end function

        private function load_show(param1:Function) : void
        {
            var show_url:String;
            var loader:Loader;
            var show_error:Function;
            var show_loaded:Function;
            var remove_listeners:Function;
            var param1:* = param1;
            var _fin:* = param1;
            show_error = function (event:IOErrorEvent) : void
            {
                remove_listeners();
                return;
            }// end function
            ;
            show_loaded = function (event:Event) : void
            {
                var scene_loaded:Function;
                var event:* = event;
                var _e:* = event;
                scene_loaded = function (event:Event) : void
                {
                    show_api.removeEventListener("vh_sceneLoaded", scene_loaded);
                    show_holder.addChild(show_api);
                    show_holder.host_guide.visible = false;
                    _fin();
                    return;
                }// end function
                ;
                remove_listeners();
                show_api = loader.content;
                show_api.addEventListener("vh_sceneLoaded", scene_loaded);
                return;
            }// end function
            ;
            remove_listeners = function () : void
            {
                loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, show_loaded);
                loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, show_error);
                return;
            }// end function
            ;
            Security.allowDomain("content.oddcast.com");
            show_url = SHOW_URL;
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, show_loaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, show_error);
            loader.load(new URLRequest(show_url));
            return;
        }// end function

        private function controls_callback(event:MouseEvent) : void
        {
            var scene_loaded:Function;
            var btn_index:int;
            var event:* = event;
            var play_scene_audio:* = function (param1:int) : void
            {
                trace("Main_Sitepal::controls_callback::play_scene_audio - param1 " + param1);
                var _loc_2:String = null;
                switch(param1)
                {
                    case 1:
                    {
                        _loc_2 = play_intro_audios ? (audio_logic.AUDIO_TYPE_KARA_INTRO) : (audio_logic.AUDIO_TYPE_KARA);
                        speak_audio(audio_logic.get_audio(_loc_2));
                        break;
                    }
                    case 2:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_OBAMA));
                        break;
                    }
                    case 3:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 4:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DANA));
                        break;
                    }
                    case 5:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 6:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 7:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 8:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 9:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 10:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 11:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DANA));
                        break;
                    }
                    case 12:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 13:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DANA));
                        break;
                    }
                    case 14:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 15:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 16:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 17:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DANA));
                        break;
                    }
                    case 18:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 19:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 20:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 21:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 22:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DANA));
                        break;
                    }
                    case 23:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
                        break;
                    }
                    case 24:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_ANGELA));
                        break;
                    }
                    case 25:
                    {
                        speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_PETE));
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
            ;
            trace("Main_Sitepal::controls_callback - event " + event.currentTarget.name);
            var _e:* = event;
            trace("Main_Sitepal::controls_callback - _e " + _e.currentTarget.name);
            scene_loaded = function (event:Event) : void
            {
                show_api.removeEventListener("vh_sceneLoaded", scene_loaded);
                play_scene_audio(cur_scene_index);
                toggle_main_loader(false);
                return;
            }// end function
            ;
            switch(_e.currentTarget)
            {
                case controls.btn_play:
                {
                    this.play_scene_audio(cur_scene_index);
                    toggle_mute(false);
                    break;
                }
                case controls.btn_stop:
                {
                    stop_audio();
                    break;
                }
                case controls.btn_mute:
                {
                    toggle_mute(!is_muted);
                    break;
                }
                case controls.btn_emo_1:
                {
                    show_api.setFacialExpression("OpenSmile", controls.EMO_DURATION_SEC, ANIMATION_INTENSITY);
                    break;
                }
                case controls.btn_emo_2:
                {
                    show_api.setFacialExpression("Sad", controls.EMO_DURATION_SEC, ANIMATION_INTENSITY);
                    break;
                }
                case controls.btn_emo_3:
                {
                    show_api.setFacialExpression("Angry", controls.EMO_DURATION_SEC, ANIMATION_INTENSITY);
                    break;
                }
                case controls.btn_emo_4:
                {
                    show_api.setFacialExpression("Surprise", controls.EMO_DURATION_SEC, ANIMATION_INTENSITY);
                    break;
                }
                case controls.btn_upload:
                {
                    stop_audio();
                    break;
                }
                case controls.btn_watch:
                {
                    stop_audio();
                    break;
                }
                default:
                {
                    if (_e.currentTarget.name.search("mc_") != -1)
                    {
                        trace("Main_Sitepal::controls_callback ***");
                        btn_index = parseInt(this["selected_btn_" + _e.currentTarget.name.split("_")[1]]);
                    }
                    else
                    {
                        trace("Main_Sitepal::controls_callback *-*");
                        btn_index = parseInt(_e.target.name.split("_")[1]);
                    }
                    trace("Main_Sitepal::controls_callback - btn_index=" + btn_index + "\n");
                    if (!isNaN(btn_index))
                    {
                        if (cur_scene_index == btn_index)
                        {
                            trace("Main_Sitepal::controls_callback - NO CHANGE=\n");
                            return;
                        }
                        play_intro_audios = false;
                        stop_audio();
                        cur_scene_index = btn_index;
                        toggle_main_loader(true);
                        show_api.addEventListener("vh_sceneLoaded", scene_loaded);
                        show_api.gotoScene(btn_index);
                        controls.toggle_emotions(_e.currentTarget.name);
                    }
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function show_ready() : void
        {
            allow_external_calls();
            var _loc_1:int = 0;
            controls.alpha = 0;
            uyp.alpha = _loc_1;
            HydroTween.go(controls, {alpha:1}, 0.5, 0);
            HydroTween.go(uyp, {alpha:1}, 0.5, 0);
            HydroTween.go(txt, {alpha:1}, 0.5, 0);
            controls.visible = true;
            prep_right_click_menu(show_api);
            toggle_main_loader(false);
            if (so_convo.is_user_in_same_session())
            {
            }
            else if (loaderInfo.parameters.introaudio != "0")
            {
                speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_TIME));
                speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_VISITS));
                speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_DAY));
                speak_audio(audio_logic.get_audio(audio_logic.AUDIO_TYPE_KARA_INTRO));
            }
            return;
        }// end function

        private function toggle_main_loader(param1:Boolean) : void
        {
            main_loader.visible = param1;
            return;
        }// end function

        private function prepare_controls() : void
        {
            controls.mc_3d1.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.mc_3d2.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.mc_2d1.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.mc_2d2.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_play.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_stop.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_mute.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_1.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_emo_1.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_emo_2.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_emo_3.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_emo_4.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_upload.addEventListener(MouseEvent.CLICK, controls_callback);
            controls.btn_watch.addEventListener(MouseEvent.CLICK, controls_callback);
            if (so_convo.initially_muted())
            {
                toggle_mute(true);
            }
            return;
        }// end function

    }
}
