package vhss.api
{
    import com.oddcast.assets.structures.*;
    import flash.events.*;
    import flash.net.*;
    import vhss.*;
    import vhss.api.requests.*;
    import vhss.events.*;

    public class BGRequester extends Requester
    {
        private var _url_req:URLRequest;

        public function BGRequester()
        {
            return;
        }// end function

        override public function load(param1:APIRequest) : void
        {
            _url_req = new URLRequest(Constants.VHSS_DOMAIN + Constants.BG_PHP);
            _url_req.data = new URLVariables("bgname=" + escape(param1.name) + "&acc=" + param1.account_id);
            _url_req.method = URLRequestMethod.GET;
            super.load(param1);
            return;
        }// end function

        override protected function getURLRequest() : URLRequest
        {
            return _url_req;
        }// end function

        override protected function e_complete(event:Event) : void
        {
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:uint = 0;
            var _loc_2:* = URLLoader(event.target);
            var _loc_3:* = _loc_2.data as String;
            if (_loc_3.indexOf("location") == 0)
            {
                _loc_4 = _loc_3.split("&");
                _loc_6 = "bg";
                _loc_7 = 0;
                while (_loc_7 < _loc_4.length)
                {
                    
                    if (String(_loc_4[_loc_7]).indexOf("location") == 0)
                    {
                        _loc_5 = String(_loc_4[_loc_7]).substr((String(_loc_4[_loc_7]).indexOf("=") + 1));
                    }
                    if (String(_loc_4[_loc_7]).indexOf("type") == 0)
                    {
                        _loc_6 = String(_loc_4[_loc_7]).substr((String(_loc_4[_loc_7]).indexOf("=") + 1));
                    }
                    _loc_7 = _loc_7 + 1;
                }
                if (_loc_5 != "ERROR")
                {
                    dispatchEvent(new APIEvent(APIEvent.BG_URL, new BackgroundStruct(_loc_5, 0, _loc_6)));
                }
            }
            return;
        }// end function

    }
}
