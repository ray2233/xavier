package vhss.dataHandler
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.audio.*;
    import vhss.*;
    import vhss.dataHandler.*;
    import vhss.structures.*;

    public class PlayerXMLHandler extends Object implements IXMLHandler
    {
        private var player_xml:XML;
        private var error_url:String;

        public function PlayerXMLHandler(param1:XML)
        {
            player_xml = param1;
            var _loc_2:* = player_xml.params;
            if (_loc_2.hasOwnProperty("secure_domains"))
            {
                Constants.verifyDomains(_loc_2.secure_domains.D);
            }
            Constants.IS_AI_ENABLED = _loc_2.hasOwnProperty("ai") && _loc_2.ai == "1" && Constants.IS_ENABLED_DOMAIN;
            Constants.IS_FILTERED = _loc_2.hasOwnProperty("badwords") && _loc_2.badwords == "1";
            if (_loc_2.hasOwnProperty("secureplayback") && _loc_2.secureplayback == "1" && !Constants.IS_ENABLED_DOMAIN && Constants.PAGE_DOMAIN.indexOf("oddcast.com") == -1)
            {
                error_url = _loc_2.errorfile.toString();
                if (_loc_2.hasOwnProperty("content_base_url"))
                {
                    error_url = _loc_2.content_base_url.toString() + error_url;
                }
            }
            if (_loc_2.hasOwnProperty("online") && _loc_2.online == "1")
            {
                Constants.ONLINE = true;
            }
            Constants.INTERNAL_MODE = _loc_2.hasOwnProperty("internalmode") ? (_loc_2.internalmode.toString()) : (null);
            return;
        }// end function

        public function getErrorFile() : String
        {
            return error_url;
        }// end function

        public function getShowData() : SlideShowStruct
        {
            var _loc_1:* = player_xml.params;
            var _loc_2:* = player_xml.assets;
            var _loc_3:* = new SlideShowStruct();
            _loc_3.show_xml = player_xml;
            _loc_3.account_id = _loc_1.hasOwnProperty("account") ? (_loc_1.account) : (_loc_1.door);
            _loc_3.show_id = _loc_1.showid;
            _loc_3.edition_id = _loc_1.edition;
            _loc_3.door_id = _loc_1.door;
            _loc_3.id = _loc_1.id;
            _loc_3.name = _loc_1.name;
            if (_loc_1.hasOwnProperty("bg_color"))
            {
                _loc_3.bg_color = _loc_1.bg_color;
            }
            if (_loc_1.hasOwnProperty("aiengine"))
            {
                _loc_3.ai_engine_id = _loc_1.aiengine;
            }
            if (_loc_1.hasOwnProperty("track_url"))
            {
                _loc_3.track_url = _loc_1.track_url;
            }
            _loc_3.oh_dom = _loc_1.hasOwnProperty("oh_base_url") ? (_loc_1.oh_base_url.toString()) : (Constants.RELATIVE_URL);
            _loc_3.content_dom = _loc_1.hasOwnProperty("content_base_url") ? (_loc_1.content_base_url.toString()) : (Constants.RELATIVE_URL);
            if (_loc_1.hasOwnProperty("tts_domain"))
            {
                _loc_3.tts_dom = _loc_1.tts_domain.toString();
            }
            if (_loc_2.hasOwnProperty("loader"))
            {
                _loc_3.loader_url = _loc_2.loader.toString().indexOf("http") == 0 ? (_loc_2.loader.toString()) : (_loc_3.content_dom + _loc_2.loader.toString());
                _loc_3.loaderIsCustom = _loc_2.loader.@custom.toString() == "1" ? (true) : (false);
            }
            if (_loc_2.hasOwnProperty("watermark"))
            {
                _loc_3.watermark_url = _loc_2.watermark.toString().indexOf("http") == 0 ? (_loc_2.watermark.toString()) : (_loc_3.content_dom + _loc_2.watermark.toString());
            }
            _loc_3.scenes = getSceneData(_loc_3);
            if (_loc_1.hasOwnProperty("volume"))
            {
                _loc_3.volume = parseInt(_loc_1.volume.toString());
            }
            return _loc_3;
        }// end function

        private function getSceneData(param1:SlideShowStruct) : Array
        {
            var _loc_3:XML = null;
            var _loc_4:SceneStruct = null;
            var _loc_2:* = new Array();
            for each (_loc_3 in player_xml..scene)
            {
                
                _loc_4 = new SceneStruct();
                _loc_4.id = _loc_3.id;
                _loc_4.playback_limit = int(_loc_3.playbacklimit);
                _loc_4.playback_interval = int(_loc_3.playbackdays);
                if (_loc_3.hasOwnProperty("autoadv"))
                {
                    _loc_4.auto_advance = int(_loc_3.autoadv) >= 0;
                }
                if (_loc_4.auto_advance)
                {
                    _loc_4.advance_delay = int(_loc_3.autoadv);
                }
                _loc_4.mouse_follow = int(_loc_3.mouse);
                _loc_4.host = getHostData(_loc_3, param1, _loc_4);
                _loc_4.bg = getBGData(_loc_3, param1, _loc_4);
                _loc_4.skin = getSkinData(_loc_3, param1, _loc_4);
                _loc_4.audio = getAudioData(_loc_3, param1, _loc_4);
                if (_loc_3.hasOwnProperty("link") && _loc_3.link.@href != null && !Constants.SUPPRESS_LINK)
                {
                    _loc_4.link = new LinkStruct();
                    _loc_4.link.url = _loc_3.link.@href;
                    _loc_4.link.target = _loc_3.link.@window != null ? (_loc_3.link.@window) : ("_blank");
                    _loc_4.link.is_start_launch = _loc_3.link.@auto == "start";
                    _loc_4.link.is_end_launch = _loc_3.link.@auto == "end";
                    _loc_4.link.is_button_launch = _loc_3.link.@button == "1";
                    if (_loc_3.link.@delay != null)
                    {
                        _loc_4.link.auto_delay = parseInt(_loc_3.link.@delay) * 1000;
                    }
                }
                _loc_2.push(_loc_4);
            }
            return _loc_2;
        }// end function

        private function getHostData(param1:XML, param2:SlideShowStruct, param3:SceneStruct) : HostStruct
        {
            var _assets_list:XMLList;
            var _hxl:XML;
            var _hurl:String;
            var _exl:XML;
            var _eng_type:String;
            var _hs:HostStruct;
            var t_hurl:String;
            var $sx:* = param1;
            var $ss:* = param2;
            var $scs:* = param3;
            if ($sx.avatar.hasSimpleContent())
            {
                return null;
            }
            _assets_list = player_xml.assets;
            var _loc_6:int = 0;
            var _loc_7:* = _assets_list.avatar;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_7[_loc_6];
                with (_loc_7[_loc_6])
                {
                    if (@id == $sx.avatar.id)
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            _hxl = _loc_5[0];
            _hurl = _hxl.toString();
            var _loc_6:int = 0;
            var _loc_7:* = _assets_list.engine;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_7[_loc_6];
                with (_loc_7[_loc_6])
                {
                    if (@id == _hxl.@engine)
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            _exl = _loc_5[0];
            _eng_type = _exl.@type.toLowerCase();
            if ($sx.avatar.hasOwnProperty("scale"))
            {
                $scs.host_scale = int($sx.avatar.scale);
            }
            if ($sx.avatar.hasOwnProperty("visible"))
            {
                $scs.host_visible = $sx.avatar.visible.toString() == "true";
            }
            if ($sx.avatar.hasOwnProperty("x"))
            {
                $scs.host_x = int($sx.avatar.x);
            }
            if ($sx.avatar.hasOwnProperty("y"))
            {
                $scs.host_y = int($sx.avatar.y);
            }
            if ($sx.avatar.hasOwnProperty("expression"))
            {
                $scs.host_exp = $sx.avatar.expression.toString();
                if ($sx.avatar.expression.@amp != undefined)
                {
                    $scs.host_exp_intensity = $sx.avatar.expression.@amp;
                }
            }
            if (_eng_type == "3d")
            {
                if ($ss.content_dom.length > 0 && _hurl.indexOf("http") != 0)
                {
                    _hurl = $ss.content_dom + _hurl;
                }
                _hs = new HostStruct(_hurl, $sx.avatar.id, "host_3d");
            }
            else
            {
                t_hurl = _hurl.split("?")[0];
                if (t_hurl.indexOf("http") != 0)
                {
                    t_hurl = $ss.oh_dom + t_hurl;
                }
                _hs = new HostStruct(t_hurl, $sx.avatar.id, "host_2d");
            }
            _hs.cs = _hurl.split("cs=")[1];
            if (_exl.@url.indexOf("http") != 0 && $ss.oh_dom.length > 0)
            {
                if ($ss.oh_dom.charAt(($ss.oh_dom.length - 1)) != "/" && _exl.@url.charAt(0) != "/")
                {
                    _exl.@url = "/" + _exl.@url;
                }
                _hs.engine.url = $ss.oh_dom + _exl.@url;
            }
            else
            {
                _hs.engine.url = _exl.@url;
            }
            _hs.engine.type = _exl.@type.toLowerCase();
            _hs.engine.id = _hxl.@engine;
            return _hs;
        }// end function

        private function getBGData(param1:XML, param2:SlideShowStruct, param3:SceneStruct) : BackgroundStruct
        {
            var _assets_list:XMLList;
            var _xl:XML;
            var _burl:String;
            var _btype:String;
            var _bs:BackgroundStruct;
            var $sx:* = param1;
            var $ss:* = param2;
            var $scs:* = param3;
            if ($sx.bg.hasSimpleContent())
            {
                return null;
            }
            _assets_list = player_xml.assets;
            if ($sx.bg.hasOwnProperty("visible"))
            {
                $scs.bg_visible = $sx.bg.visible == "true" || $sx.bg.visible == "1";
            }
            var _loc_6:int = 0;
            var _loc_7:* = _assets_list.bg;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_7[_loc_6];
                with (_loc_7[_loc_6])
                {
                    if (@id == $sx.bg.id)
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            _xl = _loc_5[0];
            _burl = _xl.toString().indexOf("http") != 0 && $ss.content_dom.length > 0 ? ($ss.content_dom + _xl) : (_xl);
            _btype = _xl.@type;
            if ($sx.bg.hasOwnProperty("scale"))
            {
                $scs.backgroundTransform = {scaleX:parseFloat($sx.bg.scale) * 0.01, scaleY:parseFloat($sx.bg.scale) * 0.01};
            }
            _bs = new BackgroundStruct(_burl, $sx.bg.id, _btype);
            return _bs;
        }// end function

        private function getAudioData(param1:XML, param2:SlideShowStruct, param3:SceneStruct) : AudioStruct
        {
            var _assets_list:XMLList;
            var _as:AudioStruct;
            var _id_node:String;
            var t_id_list:XMLList;
            var t_audio_ar:Array;
            var n:int;
            var _xl:XML;
            var t_commas_ar:Array;
            var i:int;
            var _code:int;
            var _engine:int;
            var _lang:int;
            var _voice:int;
            var _fx_type:String;
            var _fx_level:Number;
            var $sx:* = param1;
            var $ss:* = param2;
            var $scs:* = param3;
            if (!$sx.audio.hasOwnProperty("id"))
            {
                if ($sx.audio.hasOwnProperty("play"))
                {
                    $scs.play_mode = $sx.audio.play;
                }
                return null;
            }
            else
            {
                _assets_list = player_xml.assets;
                _as = new AudioStruct();
                _id_node = $sx.audio.hasOwnProperty("tempid") ? ("tempid") : ("id");
                t_id_list = $sx.audio[_id_node];
                t_audio_ar = new Array();
                n;
                while (n < t_id_list.length())
                {
                    
                    t_commas_ar = t_id_list[n].split(",");
                    i;
                    while (i < t_commas_ar.length)
                    {
                        
                        t_audio_ar.push(t_commas_ar[i]);
                        i = (i + 1);
                    }
                    n = (n + 1);
                }
                _as.id = t_audio_ar[int(Math.random() * t_audio_ar.length)];
                $scs.play_mode = $sx.audio.play;
                var _loc_6:int = 0;
                var _loc_7:* = _assets_list.audio;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        if ([_id_node] == _as.id)
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
                _xl = _loc_5[0];
                if (_xl.@type == "tts" || _xl.text.toString().length > 1)
                {
                    CachedTTS.setDomain($ss.tts_dom);
                    _code = parseInt(_xl.voice.toString());
                    _engine = Math.floor(_code / 100000);
                    _lang = Math.floor(_code % 100000 / 1000);
                    _voice = Math.floor(_code % 100);
                    _fx_type;
                    if (_xl.hasOwnProperty("fx_type") && _xl.hasOwnProperty("fx_level"))
                    {
                        _fx_type = _xl.fx_type.toString();
                        _fx_level = parseInt(_xl.fx_level.toString());
                    }
                    _as.url = CachedTTS.getTTSURL(unescape(unescape(_xl.text.toString())), _voice, _lang, _engine, _fx_type, _fx_level);
                }
                else
                {
                    _as.url = _xl.toString().indexOf("http") != 0 && $ss.content_dom.length > 0 ? ($ss.content_dom + _xl.toString()) : (_xl.toString());
                }
                return _as;
            }
        }// end function

        private function getSkinData(param1:XML, param2:SlideShowStruct, param3:SceneStruct) : SkinStruct
        {
            var _assets_list:XMLList;
            var _ss:SkinStruct;
            var _xl:XML;
            var $sx:* = param1;
            var $ss:* = param2;
            var $scs:* = param3;
            if ($sx.skin.hasSimpleContent())
            {
                return null;
            }
            _assets_list = player_xml.assets;
            _ss = new SkinStruct();
            _ss.id = $sx.skin.id;
            var _loc_6:int = 0;
            var _loc_7:* = _assets_list.skin;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_7[_loc_6];
                with (_loc_7[_loc_6])
                {
                    if (@id == $sx.skin.id)
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            _xl = _loc_5[0];
            _ss.url = _xl.toString().indexOf("http") != 0 && $ss.content_dom.length > 0 ? ($ss.content_dom + _xl.toString()) : (_xl.toString());
            $scs.skin_conf = XML($sx.skin.SKINCONF);
            return _ss;
        }// end function

    }
}
