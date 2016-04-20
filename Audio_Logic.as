package 
{

    public class Audio_Logic extends Object
    {
        private var num_of_visits_to_site:int;
        public var AUDIO_TYPE_PETE:String = "AUDIO_TYPE_PETE";
        public var AUDIO_TYPE_OBAMA:String = "AUDIO_TYPE_OBAMA";
        public var AUDIO_TYPE_DANA:String = "AUDIO_TYPE_DANA";
        public var AUDIO_TYPE_ANGELA:String = "AUDIO_TYPE_ANGELA";
        public var AUDIO_TYPE_DAY:String = "AUDIO_TYPE_DAY";
        public var AUDIO_TYPE_KARA:String = "AUDIO_TYPE_KARA";
        public var AUDIO_TYPE_VISITS:String = "AUDIO_TYPE_VISITS";
        private var audio_list:Audio_List;
        public var AUDIO_TYPE_TIME:String = "AUDIO_TYPE_TIME";
        public var AUDIO_TYPE_KARA_INTRO:String = "AUDIO_TYPE_KARA_INTRO";

        public function Audio_Logic()
        {
            audio_list = new Audio_List();
            return;
        }// end function

        private function audio_on_day() : String
        {
            var _loc_1:int = 0;
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            _loc_1 = new Date().getDay();
            _loc_2 = audio_list.DAYS[_loc_1];
            if (_loc_2.length > 0)
            {
                _loc_3 = Math.random() * _loc_2.length;
                return _loc_2[_loc_3];
            }
            return "";
        }// end function

        private function audio_on_time() : String
        {
            var _loc_1:* = new Date().getHours();
            var _loc_2:int = 0;
            if (_loc_1 >= 0 && _loc_1 < 3)
            {
                _loc_2 = 0;
            }
            else if (_loc_1 >= 3 && _loc_1 < 11)
            {
                _loc_2 = 1;
            }
            else if (_loc_1 >= 11 && _loc_1 < 13)
            {
                _loc_2 = 2;
            }
            else if (_loc_1 >= 13 && _loc_1 < 17)
            {
                _loc_2 = 2;
            }
            else if (_loc_1 >= 17 && _loc_1 < 22)
            {
                _loc_2 = 3;
            }
            else if (_loc_1 >= 22 && _loc_1 < 24)
            {
                _loc_2 = 4;
            }
            return audio_list.TIME[_loc_2];
        }// end function

        public function init(param1:int) : void
        {
            num_of_visits_to_site = param1;
            return;
        }// end function

        public function get_audio(param1:String) : String
        {
            switch(param1)
            {
                case AUDIO_TYPE_TIME:
                {
                    return audio_on_time();
                }
                case AUDIO_TYPE_DAY:
                {
                    return audio_on_day();
                }
                case AUDIO_TYPE_VISITS:
                {
                    return audio_on_visits();
                }
                case AUDIO_TYPE_KARA:
                {
                    return audio_per_user("KARA");
                }
                case AUDIO_TYPE_KARA_INTRO:
                {
                    return audio_per_user("KARA_INTRO");
                }
                case AUDIO_TYPE_OBAMA:
                {
                    return audio_per_user("OBAMA");
                }
                case AUDIO_TYPE_ANGELA:
                {
                    return audio_per_user("ANGELA");
                }
                case AUDIO_TYPE_DANA:
                {
                    return audio_per_user("DANA");
                }
                case AUDIO_TYPE_PETE:
                {
                    return audio_per_user("PETE");
                }
                default:
                {
                    break;
                    break;
                }
            }
            return "";
        }// end function

        private function audio_per_user(param1:String) : String
        {
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            _loc_2 = audio_list[param1];
            _loc_3 = Math.random() * _loc_2.length;
            return _loc_2[_loc_3];
        }// end function

        private function audio_on_visits() : String
        {
            var _loc_1:int = 0;
            if (num_of_visits_to_site < 3)
            {
                return audio_list.VISITS[num_of_visits_to_site];
            }
            _loc_1 = Math.random() * audio_list.VISITS.length;
            return audio_list.VISITS[_loc_1];
        }// end function

    }
}
