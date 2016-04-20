package vhss.api
{
    import flash.events.*;
    import flash.net.*;
    import vhss.*;
    import vhss.api.requests.*;
    import vhss.events.*;

    public class AIRequester extends Requester
    {
        private var _ai_request:APIAIRequest;
        private var _url_req:URLRequest;

        public function AIRequester()
        {
            return;
        }// end function

        override public function load(param1:APIRequest) : void
        {
            var _loc_2:* = APIAIRequest(param1);
            _ai_request = _loc_2;
            _url_req = new URLRequest(Constants.VHSS_DOMAIN + Constants.AI_PHP);
            _url_req.data = new URLVariables("text=" + escape(_loc_2.ai_text) + "&botid=" + _loc_2.bot + "&acc=" + _loc_2.account_id + "&aiEngine=" + _loc_2.ai_engine_id);
            _url_req.method = URLRequestMethod.POST;
            super.load(_loc_2);
            return;
        }// end function

        override protected function getURLRequest() : URLRequest
        {
            return _url_req;
        }// end function

        override protected function e_complete(event:Event) : void
        {
            var _loc_4:Array = null;
            var _loc_5:AIResponse = null;
            var _loc_6:uint = 0;
            var _loc_2:* = URLLoader(event.target);
            var _loc_3:* = _loc_2.data as String;
            if (_loc_3.indexOf("response") == 0)
            {
                _loc_4 = _loc_3.split("&");
                _loc_5 = new AIResponse();
                _loc_5.ai_request = _ai_request;
                _loc_6 = 0;
                while (_loc_6 < _loc_4.length)
                {
                    
                    if (String(_loc_4[_loc_6]).indexOf("response") == 0)
                    {
                        _loc_5.ai_request.name = String(_loc_4[_loc_6]).substr((String(_loc_4[_loc_6]).indexOf("=") + 1));
                    }
                    else if (String(_loc_4[_loc_6]).indexOf("location") == 0)
                    {
                        _loc_5.url = String(_loc_4[_loc_6]).substr((String(_loc_4[_loc_6]).indexOf("=") + 1));
                    }
                    else if (String(_loc_4[_loc_6]).indexOf("aiDisplayTag") == 0)
                    {
                        _loc_5.display_tag = String(_loc_4[_loc_6]).substr((String(_loc_4[_loc_6]).indexOf("=") + 1));
                    }
                    else if (String(_loc_4[_loc_6]).indexOf("display") == 0)
                    {
                        _loc_5.display_text = String(_loc_4[_loc_6]).substr((String(_loc_4[_loc_6]).indexOf("=") + 1));
                    }
                    _loc_6 = _loc_6 + 1;
                }
                dispatchEvent(new APIEvent(APIEvent.AI_COMPLETE, _loc_5));
            }
            else if (_loc_3.toLowerCase().indexOf("err") == 0)
            {
            }
            return;
        }// end function

    }
}
