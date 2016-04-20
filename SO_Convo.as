package 
{
    import com.oddcast.utils.*;

    public class SO_Convo extends Object
    {
        private const BROWSER_TIMEOUT_MILISEC:Number = 420000;
        private const BROWSER_TIMEOUT_MIN:Number = 7;
        private const SO_NAME:String = "sitepalSite";
        public var can_access_so:Boolean = true;
        public var num_of_user_visits:int;
        private var SO_EXPIRATION_DATE:Date;
        private var shared_obj:OddcastSharedObject;

        public function SO_Convo()
        {
            SO_EXPIRATION_DATE = new Date(3333, 1, 1, 1, 1, 1, 1);
            can_access_so = true;
            return;
        }// end function

        public function save_mute(param1:Boolean) : void
        {
            if (can_access_so)
            {
                shared_obj.write({mute:param1 ? (1) : (0)});
            }
            return;
        }// end function

        public function audio_spoken() : void
        {
            if (can_access_so)
            {
                shared_obj.write({last_audio_spoken_time:new Date().getTime()});
            }
            return;
        }// end function

        public function increment_user_visits() : void
        {
            var _loc_1:int = 0;
            var _loc_2:String = null;
            if (can_access_so)
            {
                _loc_1 = parseInt(shared_obj.getDataObject().visits);
                _loc_2 = isNaN(_loc_1) ? ("0") : (((_loc_1 + 1)).toString());
                shared_obj.write({visits:_loc_2});
                num_of_user_visits = isNaN(_loc_1) ? (0) : (_loc_1);
            }
            return;
        }// end function

        public function initially_muted() : Boolean
        {
            var _loc_1:Boolean = false;
            if (can_access_so)
            {
                _loc_1 = shared_obj.getDataObject().mute == 1;
                return _loc_1;
            }
            return false;
        }// end function

        public function init() : void
        {
            try
            {
                shared_obj = new OddcastSharedObject(SO_NAME, SO_EXPIRATION_DATE, OddcastSharedObject.PERMANENT);
            }
            catch (_e:Error)
            {
                can_access_so = false;
            }
            return;
        }// end function

        public function is_user_in_same_session() : Boolean
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            if (can_access_so)
            {
                _loc_1 = shared_obj.getDataObject().last_audio_spoken_time;
                if (!isNaN(_loc_1))
                {
                    _loc_2 = new Date().getTime();
                    _loc_3 = new Date(_loc_2 - _loc_1).getMinutes();
                    return _loc_3 <= BROWSER_TIMEOUT_MIN;
                }
            }
            return false;
        }// end function

    }
}
