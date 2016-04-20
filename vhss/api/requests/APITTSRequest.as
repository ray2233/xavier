package vhss.api.requests
{

    public class APITTSRequest extends APIAudioRequest
    {
        public var voice:String;
        public var lang:String;
        public var engine:String;
        public var fx_type:String;
        public var fx_level:String;

        public function APITTSRequest(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:String = "", param7:Number = 0)
        {
            super(param1, param7, false);
            voice = param2;
            lang = param3;
            engine = param4;
            fx_type = param5;
            fx_level = param6;
            return;
        }// end function

    }
}
