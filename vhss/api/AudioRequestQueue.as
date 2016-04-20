package vhss.api
{
    import flash.events.*;
    import vhss.api.requests.*;
    import vhss.events.*;

    public class AudioRequestQueue extends RequestQueue
    {
        private var _dom:String;
        private var _account:String;
        private var _cacher:CacheAudioQueue;
        private var _audio_by_name:AudioRequester;

        public function AudioRequestQueue()
        {
            _audio_by_name = new AudioRequester();
            _audio_by_name.addEventListener(APIEvent.SAY_AUDIO_URL, e_complete);
            _cacher = new CacheAudioQueue();
            _cacher.addEventListener(APIEvent.AUDIO_CACHED, e_audioCached);
            return;
        }// end function

        override public function destroy() : void
        {
            super.destroy();
            _cacher.removeEventListener(APIEvent.AUDIO_CACHED, e_audioCached);
            _cacher.destroy();
            _cacher = null;
            return;
        }// end function

        override protected function loadQueuedItem() : void
        {
            _audio_by_name.load(APIAudioRequest(_queue.shift()));
            return;
        }// end function

        private function e_complete(event:APIEvent) : void
        {
            _is_busy = false;
            var _loc_2:* = APIAudioRequest(event.data);
            if (_loc_2.url.indexOf("ERROR") == -1)
            {
                if (_loc_2.cache)
                {
                    _cacher.load(_loc_2);
                }
                else
                {
                    dispatchEvent(new APIEvent(APIEvent.SAY_AUDIO_URL, _loc_2));
                }
            }
            checkQueue();
            return;
        }// end function

        private function e_audioCached(event:APIEvent) : void
        {
            dispatchEvent(new APIEvent(APIEvent.AUDIO_CACHED, event.data));
            return;
        }// end function

        private function e_error(event:IOErrorEvent) : void
        {
            _is_busy = false;
            return;
        }// end function

        private function e_security(event:SecurityErrorEvent) : void
        {
            _is_busy = false;
            return;
        }// end function

    }
}
