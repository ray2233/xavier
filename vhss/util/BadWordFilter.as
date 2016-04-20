package vhss.util
{
    import com.oddcast.event.*;
    import com.oddcast.utils.*;
    import flash.events.*;
    import vhss.*;

    public class BadWordFilter extends EventDispatcher
    {
        private var is_ready:Boolean = false;
        private var word_array:Array;
        private var badwords_xml:XML;
        private var xml_loader:XMLLoader;
        private var lang_badwords_xml:XMLList;
        private var filters:Object;
        private var _onCompleteCallback:Function;
        private var _onErrorCallback:Function;
        private var _xmlUrl:String;

        public function BadWordFilter(param1:String)
        {
            _xmlUrl = Constants.BAD_WORDS_PHP + param1;
            return;
        }// end function

        public function get wordsXmlUrl() : String
        {
            return _xmlUrl;
        }// end function

        public function get isReady() : Boolean
        {
            return is_ready;
        }// end function

        public function load(param1:Function = null, param2:Function = null) : void
        {
            _onCompleteCallback = param1;
            _onErrorCallback = param2;
            XMLLoader.loadXML(_xmlUrl, e_xmlLoaded);
            return;
        }// end function

        private function e_xmlLoaded(param1:XML) : void
        {
            var _loc_2:Function = null;
            var _loc_4:XML = null;
            var _loc_5:String = null;
            var _loc_6:XML = null;
            var _loc_3:* = XMLLoader.checkForAlertEvent();
            if (_loc_3 != null)
            {
                _loc_2 = _onErrorCallback;
            }
            else
            {
                filters = new Object();
                badwords_xml = param1;
                for each (_loc_4 in badwords_xml.lang)
                {
                    
                    _loc_5 = "";
                    for each (_loc_6 in _loc_4.i)
                    {
                        
                        _loc_5 = _loc_5 + (_loc_6.@w + "|");
                    }
                    _loc_5 = _loc_5.substr(0, (_loc_5.length - 1));
                    _loc_5 = "\\b(" + _loc_5 + ")\\b";
                    filters[_loc_4.@id] = _loc_5;
                }
                is_ready = true;
                badwords_xml = param1;
                _loc_2 = _onCompleteCallback;
            }
            _onCompleteCallback = null;
            _onErrorCallback = null;
            if (_loc_2 != null)
            {
                this._loc_2();
            }
            return;
        }// end function

        private function replacer() : String
        {
            arguments = new activation;
            var t_word:String;
            var t_replace:String;
            var t_default:String;
            var arguments:* = arguments;
            t_word = [0];
            var _loc_4:int = 0;
            var _loc_5:* = lang_badwords_xml.i;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@w == t_word)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            t_replace = unescape(_loc_3.@r.toString());
            t_default = unescape(lang_badwords_xml.@rep.toString());
            if (length > 0)
            {
                return ;
            }
            if (length > 0)
            {
                return ;
            }
            return ;
        }// end function

        public function filter(param1:String, param2:String) : String
        {
            var t_filter_str:String;
            var t_rx:RegExp;
            var t_str:String;
            var $str:* = param1;
            var $language:* = param2;
            if (!is_ready)
            {
                return $str;
            }
            if ($language.length > 0 && filters[$language] != null)
            {
                var _loc_5:int = 0;
                var _loc_6:* = badwords_xml.lang;
                var _loc_4:* = new XMLList("");
                for each (_loc_7 in _loc_6)
                {
                    
                    var _loc_8:* = _loc_6[_loc_5];
                    with (_loc_6[_loc_5])
                    {
                        if (@id == $language)
                        {
                            _loc_4[_loc_5] = _loc_7;
                        }
                    }
                }
                lang_badwords_xml = _loc_4;
                t_filter_str = filters[$language];
                t_rx = new RegExp(t_filter_str, "gi");
                t_str = $str.replace(t_rx, replacer);
                return t_str;
            }
            else
            {
                return $str;
            }
        }// end function

        public function destroy() : void
        {
            XMLLoader.destroy();
            return;
        }// end function

    }
}
