package vhss.api.requests
{

    public class APIAIRequest extends APITTSRequest
    {
        public var ai_text:String;
        public var ai_engine_id:String;
        public var bot:String;

        public function APIAIRequest(param1:String, param2:String, param3:String, param4:String, param5:String = "0", param6:String = "", param7:String = "", param8:Number = 0)
        {
            super("", param2, param3, param4, param6, param7, param8);
            ai_text = param1;
            bot = param5;
            return;
        }// end function

    }
}
