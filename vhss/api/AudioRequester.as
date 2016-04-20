package vhss.api
{
    import flash.events.*;
    import flash.net.*;
    import vhss.*;
    import vhss.api.requests.*;
    import vhss.events.*;

    public class AudioRequester extends Requester
    {
        private var _url_req:URLRequest;
        private var _audio_req:APIAudioRequest;

        public function AudioRequester()
        {
            return;
        }// end function

        override public function load(param1:APIRequest) : void
        {
            _audio_req = APIAudioRequest(param1);
            _url_req = new URLRequest(Constants.VHSS_DOMAIN + Constants.SAY_BY_NAME_PHP);
            _url_req.data = new URLVariables("audioname=" + escape(param1.name) + "&acc=" + param1.account_id + "&r=" + uint(Math.random() * 100000));
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
            var _loc_4:String = null;
            var _loc_2:* = URLLoader(event.target);
            var _loc_3:* = String(_loc_2.data).split("&");
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                if (_loc_3[_loc_5].indexOf("location") == 0)
                {
                    _loc_4 = _loc_3[_loc_5].split("=")[1];
                }
                _loc_5++;
            }
            if (_loc_4 == null)
            {
            }
            else
            {
                _audio_req.url = _loc_4;
                dispatchEvent(new APIEvent(APIEvent.SAY_AUDIO_URL, _audio_req));
            }
            return;
        }// end function

    }
}
