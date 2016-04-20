package vhss.api
{
    import vhss.api.requests.*;

    public class AIResponse extends Object
    {
        public var ai_request:APIAIRequest;
        public var url:String;
        public var display_tag:String;
        public var display_text:String = "";

        public function AIResponse()
        {
            return;
        }// end function

    }
}
