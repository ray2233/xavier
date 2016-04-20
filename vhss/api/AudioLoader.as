package vhss.api
{
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class AudioLoader extends EventDispatcher
    {
        private var _sound:Sound;
        private var _queue:Array;

        public function AudioLoader()
        {
            _sound = new Sound();
            _sound.addEventListener(Event.COMPLETE, e_loadComplete);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, e_IOError);
            return;
        }// end function

        public function destroy() : void
        {
            _sound.removeEventListener(Event.COMPLETE, e_loadComplete);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, e_IOError);
            _sound = null;
            return;
        }// end function

        public function load(param1:String) : void
        {
            var $url:* = param1;
            try
            {
                _sound.load(new URLRequest($url));
            }
            catch ($e:Error)
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            }
            return;
        }// end function

        private function e_loadComplete(event:Event) : void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        private function e_IOError(event:IOErrorEvent) : void
        {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            return;
        }// end function

    }
}
