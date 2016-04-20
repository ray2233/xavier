package vhss.reports
{
    import com.oddcast.reports.*;
    import flash.display.*;

    public class VHSSPlayerTracker extends Object
    {
        private static var tracker:MultiUrlEventTracker;
        private static var parameters:Object;
        private static var request_url:String;
        private static var error:Error;

        public function VHSSPlayerTracker()
        {
            return;
        }// end function

        public static function setInitObject(param1:Object) : void
        {
            parameters = param1;
            return;
        }// end function

        public static function setRequestUrl(param1:String) : void
        {
            request_url = param1;
            return;
        }// end function

        public static function initTracker(param1, param2:Object, param3:LoaderInfo) : void
        {
            var _loc_4:String = null;
            var _loc_5:XMLList = null;
            var _loc_6:int = 0;
            tracker = new MultiUrlEventTracker();
            if (param1 is XMLList)
            {
                _loc_5 = param1 as XMLList;
                _loc_4 = _loc_5[0].toString();
                _loc_6 = 1;
                while (_loc_6 < _loc_5.length())
                {
                    
                    tracker.addReportingUrl(_loc_5[_loc_6].toString());
                    _loc_6++;
                }
            }
            else if (param1 is String)
            {
                _loc_4 = param1 as String;
            }
            if (_loc_4)
            {
                tracker.init(_loc_4, param2, param3);
            }
            return;
        }// end function

        public static function setEventTracker(param1:MultiUrlEventTracker) : void
        {
            tracker = param1;
            return;
        }// end function

        public static function event(param1:String, param2:String = null, param3:Number = 0, param4:String = null) : void
        {
            if (tracker != null)
            {
                tracker.event(param1, param2, param3, param4);
            }
            return;
        }// end function

        public static function destroy() : void
        {
            tracker.destroy();
            tracker = null;
            return;
        }// end function

    }
}
