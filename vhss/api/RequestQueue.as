package vhss.api
{
    import flash.events.*;
    import vhss.api.requests.*;

    public class RequestQueue extends EventDispatcher
    {
        protected var _queue:Array;
        protected var _is_busy:Boolean;

        public function RequestQueue()
        {
            _queue = new Array();
            return;
        }// end function

        public function destroy() : void
        {
            _queue = null;
            return;
        }// end function

        public function load(param1:APIRequest) : void
        {
            _queue.push(param1);
            checkQueue();
            return;
        }// end function

        protected function checkQueue() : void
        {
            if (!_is_busy && _queue.length > 0)
            {
                _is_busy = true;
                loadQueuedItem();
            }
            return;
        }// end function

        protected function loadQueuedItem() : void
        {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "You must override this function in your sub-class"));
            return;
        }// end function

    }
}
