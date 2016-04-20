package vhss.api
{
    import flash.events.*;
    import vhss.api.requests.*;
    import vhss.events.*;

    public class CacheAudioQueue extends RequestQueue
    {
        private var _cacher:AudioLoader;

        public function CacheAudioQueue()
        {
            return;
        }// end function

        override public function destroy() : void
        {
            super.destroy();
            return;
        }// end function

        override protected function loadQueuedItem() : void
        {
            var _loc_1:* = APIAudioRequest(_queue[0]);
            _cacher = new AudioLoader();
            _cacher.addEventListener(Event.COMPLETE, e_audioCached);
            _cacher.load(_loc_1.url);
            return;
        }// end function

        private function e_audioCached(event:Event) : void
        {
            _is_busy = false;
            _cacher.removeEventListener(Event.COMPLETE, e_audioCached);
            _cacher.destroy();
            _cacher = null;
            dispatchEvent(new APIEvent(APIEvent.AUDIO_CACHED, _queue.shift()));
            checkQueue();
            return;
        }// end function

    }
}
