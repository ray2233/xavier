package vhss.playback
{

    public interface IBackgroundAPI
    {

        public function IBackgroundAPI();

        function setVolume(param1:Number) : void;

        function bgPlay(param1:Number = 0) : void;

        function bgStop() : void;

        function bgReplay() : void;

        function bgPause() : void;

        function bgResume() : void;

        function getStatus() : String;

        function destroy() : void;

        function displayBgFrame(param1:Number = 0) : void;

    }
}
