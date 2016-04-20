package vhss.api.requests
{

    public class APIAudioRequest extends APIRequest
    {
        public var cache:Boolean = false;
        public var start_time:Number;
        public var url:String;

        public function APIAudioRequest(param1:String, param2:Number = 0, param3:Boolean = false)
        {
            start_time = param2;
            cache = param3;
            super(param1);
            return;
        }// end function

    }
}
