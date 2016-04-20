package org.goasap.interfaces
{

    public interface IPlayable extends IEventDispatcher
    {

        public function IPlayable();

        function get state() : String;

        function start() : Boolean;

        function stop() : Boolean;

        function pause() : Boolean;

        function resume() : Boolean;

        function skipTo(param1:Number) : Boolean;

    }
}
