package vhss
{
    import com.oddcast.encryption.*;
    import com.pagodaflash.math.*;

    public class Constants extends Object
    {
        private static var _vhssConfigUrl:String = "http://api.oddcast.com/vhss/vhss_v5_config.xml";
        public static const VHSS_PLAYER_VERSION:String = "5.1.15.0";
        public static const VHSS_PLAYER_DATE:String = "02.22.11 -- 03:16  ";
        public static var FLASH_PLAYER_VERSION:String;
        public static var VHSS_DOMAIN:String = "http://vhost.oddcast.com";
        private static var _VHSS_DOMAIN_SECURE:String = "https://vhost.oddcast.com";
        private static var _VHSS_DOMAIN_DEV:String = "http://vhss-vd.oddcast.com";
        private static var _VHSS_DOMAIN_DEV_SECURE:String = "https://vhss-vd.oddcast.com";
        private static var _VHSS_DOMAIN_STAGING:String = "http://vhss-vs.oddcast.com";
        private static var _VHSS_DOMAIN_STAGING_SECURE:String = "https://vhss-vs.oddcast.com";
        public static var TTS_DOMAIN:String = "http://cache-a.oddcast.com";
        private static var _TTS_DOMAIN_SECURE:String = "https://cache.oddcast.com";
        private static var _TTS_DOMAIN_DEV:String = "http://cache-vd.oddcast.com";
        private static var _TTS_DOMAIN_DEV_SECURE:String = "https://cache-vd.oddcast.com";
        private static var _TTS_DOMAIN_STAGING:String = "http://cache-vs.oddcast.com";
        private static var _TTS_DOMAIN_STAGING_SECURE:String = "https://cache-vs.oddcast.com";
        public static var SCENE_STATUS_PHP:String = "http://data.oddcast.com/scenestatus.php";
        private static var _SCENE_STATUS_PHP_SECURE:String = "https://data.oddcast.com/scenestatus.php";
        private static var _SCENE_STATUS_PHP_DEV:String = "http://data-vd.oddcast.com/scenestatus.php";
        private static var _SCENE_STATUS_PHP_DEV_SECURE:String = "https://data-vd.oddcast.com/scenestatus.php";
        private static var _SCENE_STATUS_PHP_STAGING:String = "http://data-vs.oddcast.com/scenestatus.php";
        private static var _SCENE_STATUS_PHP_STAGING_SECURE:String = "https://data-vs.oddcast.com/scenestatus.php";
        public static var BAD_WORDS_PHP:String = "http://vhss-d.oddcast.com/php/vhss_editors/getBadWords/acc=";
        private static var _BAD_WORDS_PHP_SECURE:String = "https://vhost.oddcast.com/php/vhss_editors/getBadWords/acc=";
        private static var _BAD_WORDS_PHP_DEV:String = "http://vhss-vd.oddcast.com/php/vhss_editors/getBadWords/acc=";
        private static var _BAD_WORDS_PHP_DEV_SECURE:String = "https://vhss-vd.oddcast.com/php/vhss_editors/getBadWords/acc=";
        private static var _BAD_WORDS_PHP_STAGING:String = "http://vhss-vs.oddcast.com/php/vhss_editors/getBadWords/acc=";
        private static var _BAD_WORDS_PHP_STAGING_SECURE:String = "https://vhss-vs.oddcast.com/php/vhss_editors/getBadWords/acc=";
        public static var SITEPAL_BASE:String;
        private static var _SITEPAL_BASE_DEV:String;
        private static var _SITEPAL_BASE_STAGING:String;
        public static var SAY_BY_NAME_PHP:String = "/admin/getAudioByNameMP3.php";
        public static var AI_PHP:String = "/ai/input.php";
        public static var BG_PHP:String = "/admin/getBGByNameV2.php";
        public static var SEND_LEAD_PHP:String = "/leads/post.php";
        public static var EXPORT_XML:String = "play_scene.xml";
        public static var COMM_WINDOW:String = "http://content.dev.oddcast.com/vhss_dev/vhss_voip_component.swf";
        public static var SET_COOKIE_PHP:String;
        public static const EXP_AD_PERCENT:Number = 0.25;
        public static const EXP_AD_MAX:Number = 500;
        public static const BG_SCALE_DEFAULT:Number = 1.33;
        public static const FLV_SCALE_DEFAULT:Number = 1;
        public static const X_OFFSET_3D:int = 110;
        public static const Y_OFFSET_3D:int = -27;
        public static const SCALE_OFFSET_3D:int = -7;
        private static var _PLAYER_CONTEXT:String = "live";
        public static var IS_HTTPS:Boolean = false;
        public static var IS_ENABLED_DOMAIN:Boolean = false;
        public static var IS_AI_ENABLED:Boolean = false;
        public static var IS_FILTERED:Boolean = false;
        public static var PAGE_DOMAIN:String = "";
        public static var PLAYER_DOMAIN:String = "";
        public static var RELATIVE_URL:String = "";
        public static var EMBED_ID:String;
        public static var TRACKING_EMBED_ID:String = "7";
        public static var SUPPRESS_TRACKING:Boolean = false;
        public static var SUPPRESS_PLAY_ON_LOAD:Boolean = false;
        public static var SUPPRESS_EXPORT_XML:Boolean = false;
        public static var SUPPRESS_PLAY_ON_CLICK:Boolean = false;
        public static var SUPPRESS_LINK:Boolean = false;
        public static var SUPPRESS_AUTO_ADV:Boolean = false;
        public static var ONLINE:Boolean = false;
        public static var USE_3D_OFFSET:Boolean = true;
        public static var PLAYER_URL:String;
        public static var ERROR_REPORTING_ACTIVE:Boolean = true;
        public static var INTERNAL_MODE:String;
        public static const VOLUME_RANGE_PLAYER:Range = new Range(0, 10);
        public static const VOLUME_RANGE_2D:Range = new Range(0, 1);
        public static const VOLUME_RANGE_3D:Range = new Range(0, 100);

        public function Constants()
        {
            return;
        }// end function

        public static function set PLAYER_CONTEXT(param1:String) : void
        {
            PLAYER_URL = param1;
            if (param1.indexOf("https") == 0)
            {
                IS_HTTPS = true;
            }
            PLAYER_DOMAIN = param1.substring(param1.indexOf("://") + 3, param1.indexOf("/", param1.indexOf("://") + 3));
            if (PLAYER_DOMAIN.indexOf("dev.oddcast.com") != -1 || PLAYER_DOMAIN.indexOf("-vd.oddcast.com") != -1)
            {
                _PLAYER_CONTEXT = "dev";
            }
            else if (PLAYER_DOMAIN.indexOf("staging.oddcast.com") != -1 || PLAYER_DOMAIN.indexOf("-vs.oddcast.com") != -1)
            {
                _PLAYER_CONTEXT = "staging";
            }
            else if (PLAYER_DOMAIN.indexOf("oddcast.com") != -1)
            {
                _PLAYER_CONTEXT = "live";
            }
            else
            {
                _PLAYER_CONTEXT = "export";
            }
            switch(_PLAYER_CONTEXT)
            {
                case "staging":
                {
                    SCENE_STATUS_PHP = IS_HTTPS ? (_SCENE_STATUS_PHP_STAGING_SECURE) : (_SCENE_STATUS_PHP_STAGING);
                    VHSS_DOMAIN = IS_HTTPS ? (_VHSS_DOMAIN_STAGING_SECURE) : (_VHSS_DOMAIN_STAGING);
                    TTS_DOMAIN = IS_HTTPS ? (_TTS_DOMAIN_STAGING_SECURE) : (_TTS_DOMAIN_STAGING);
                    BAD_WORDS_PHP = IS_HTTPS ? (_BAD_WORDS_PHP_STAGING_SECURE) : (_BAD_WORDS_PHP_STAGING);
                    SITEPAL_BASE = _SITEPAL_BASE_STAGING.replace("http://", "https://");
                    break;
                }
                case "dev":
                {
                    SCENE_STATUS_PHP = IS_HTTPS ? (_SCENE_STATUS_PHP_DEV_SECURE) : (_SCENE_STATUS_PHP_DEV);
                    VHSS_DOMAIN = IS_HTTPS ? (_VHSS_DOMAIN_DEV_SECURE) : (_VHSS_DOMAIN_DEV);
                    TTS_DOMAIN = IS_HTTPS ? (_TTS_DOMAIN_DEV_SECURE) : (_TTS_DOMAIN_DEV);
                    BAD_WORDS_PHP = IS_HTTPS ? (_BAD_WORDS_PHP_DEV_SECURE) : (_BAD_WORDS_PHP_DEV);
                    SITEPAL_BASE = _SITEPAL_BASE_DEV.replace("http://", "https://");
                    break;
                }
                default:
                {
                    if (IS_HTTPS)
                    {
                        SCENE_STATUS_PHP = _SCENE_STATUS_PHP_SECURE;
                        VHSS_DOMAIN = _VHSS_DOMAIN_SECURE;
                        TTS_DOMAIN = _TTS_DOMAIN_SECURE;
                        BAD_WORDS_PHP = _BAD_WORDS_PHP_SECURE;
                        SITEPAL_BASE = SITEPAL_BASE.replace("http://", "https://");
                    }
                    break;
                    break;
                }
            }
            return;
        }// end function

        public static function get PLAYER_CONTEXT() : String
        {
            return _PLAYER_CONTEXT;
        }// end function

        public static function get vhssConfigUrl() : String
        {
            return _vhssConfigUrl;
        }// end function

        public static function verifyDomains(param1:XMLList) : void
        {
            var _loc_9:Number = NaN;
            var _loc_2:* = new md5();
            var _loc_3:* = PAGE_DOMAIN;
            var _loc_4:* = _loc_3.split(".");
            var _loc_5:* = "*." + _loc_4[_loc_4.length - 2] + "." + _loc_4[(_loc_4.length - 1)];
            var _loc_6:* = _loc_2.hash(_loc_5);
            var _loc_7:* = "*." + _loc_4[_loc_4.length - 3] + "." + _loc_4[_loc_4.length - 2] + "." + _loc_4[(_loc_4.length - 1)];
            var _loc_8:* = _loc_2.hash(_loc_7);
            if (_loc_4[(_loc_4.length - 1)] == "com" && _loc_4[_loc_4.length - 2] == "oddcast")
            {
                IS_ENABLED_DOMAIN = true;
            }
            else
            {
                if (_loc_4[0] != "www")
                {
                    _loc_3 = "www." + _loc_3;
                }
                _loc_3 = _loc_2.hash(_loc_3);
                _loc_9 = 0;
                while (_loc_9 < param1.length())
                {
                    
                    if (param1[_loc_9].@V == _loc_3)
                    {
                        IS_ENABLED_DOMAIN = true;
                        break;
                    }
                    if (param1[_loc_9].@V == _loc_6)
                    {
                        IS_ENABLED_DOMAIN = true;
                        break;
                    }
                    if (param1[_loc_9].@V == _loc_8)
                    {
                        IS_ENABLED_DOMAIN = true;
                        break;
                    }
                    _loc_9 = _loc_9 + 1;
                }
            }
            return;
        }// end function

        public static function buildConfigUrl(param1:String) : String
        {
            var _loc_2:* = param1.indexOf("https") >= 0;
            var _loc_3:* = _loc_2 ? (8) : (7);
            var _loc_4:* = param1.substring(_loc_3);
            _loc_4 = param1.substring(_loc_3).substring(0, _loc_4.indexOf("/"));
            var _loc_5:* = _loc_4.indexOf("-vd") >= 0 ? ("-vd") : (_loc_4.indexOf("-vs") >= 0 ? ("-vs") : (""));
            var _loc_6:* = _vhssConfigUrl.replace("api", "api" + _loc_5);
            var _loc_7:* = _loc_2 ? ("https://") : ("http://");
            _loc_6 = _loc_6.replace("http://", _loc_7);
            return _loc_6;
        }// end function

        public static function parseConfiguration(param1:XML) : void
        {
            VHSS_DOMAIN = param1.vhss_domain.toString();
            _VHSS_DOMAIN_SECURE = param1.vhss_domain_secure.toString();
            _VHSS_DOMAIN_DEV = param1.vhss_domain_dev.toString();
            _VHSS_DOMAIN_DEV_SECURE = param1.vhss_domain_dev_secure.toString();
            _VHSS_DOMAIN_STAGING = param1.vhss_domain_staging.toString();
            _VHSS_DOMAIN_STAGING_SECURE = param1.vhss_domain_staging_secure.toString();
            TTS_DOMAIN = param1.tts_domain.toString();
            _TTS_DOMAIN_SECURE = param1.tts_domain_secure.toString();
            _TTS_DOMAIN_DEV = param1.tts_domain_dev.toString();
            _TTS_DOMAIN_DEV_SECURE = param1.tts_domain_dev_secure.toString();
            _TTS_DOMAIN_STAGING = param1.tts_domain_staging.toString();
            _TTS_DOMAIN_STAGING_SECURE = param1.tts_domain_staging_secure.toString();
            SCENE_STATUS_PHP = param1.scene_status_php.toString();
            _SCENE_STATUS_PHP_SECURE = param1.scene_status_php_secure.toString();
            _SCENE_STATUS_PHP_DEV = param1.scene_status_php_dev.toString();
            _SCENE_STATUS_PHP_DEV_SECURE = param1.scene_status_php_dev_secure.toString();
            _SCENE_STATUS_PHP_STAGING = param1.scene_status_php_staging.toString();
            _SCENE_STATUS_PHP_STAGING_SECURE = param1.scene_status_php_staging_secure.toString();
            BAD_WORDS_PHP = param1.bad_words_php.toString();
            _BAD_WORDS_PHP_SECURE = param1.bad_words_php_secure.toString();
            _BAD_WORDS_PHP_DEV = param1.bad_words_php_dev.toString();
            _BAD_WORDS_PHP_DEV_SECURE = param1.bad_words_php_dev_secure.toString();
            _BAD_WORDS_PHP_STAGING = param1.bad_words_php_staging.toString();
            _BAD_WORDS_PHP_STAGING_SECURE = param1.bad_words_php_staging_secure.toString();
            SITEPAL_BASE = param1.sitepal_domain.toString();
            _SITEPAL_BASE_DEV = param1.sitepal_dev.toString();
            _SITEPAL_BASE_STAGING = param1.sitepal_staging.toString();
            SAY_BY_NAME_PHP = param1.say_by_name_php.toString();
            AI_PHP = param1.ai_php.toString();
            BG_PHP = param1.bg_php.toString();
            SEND_LEAD_PHP = param1.send_lead_php.toString();
            EXPORT_XML = param1.export_xml.toString();
            COMM_WINDOW = param1.comm_window.toString();
            SET_COOKIE_PHP = param1.set_cookie.toString();
            return;
        }// end function

    }
}
