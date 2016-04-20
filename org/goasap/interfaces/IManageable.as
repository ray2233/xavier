package org.goasap.interfaces
{
    import org.goasap.interfaces.*;

    public interface IManageable extends IUpdatable
    {

        public function IManageable();

        function getActiveTargets() : Array;

        function getActiveProperties() : Array;

        function isHandling(param1:Array) : Boolean;

        function releaseHandling(... args) : void;

    }
}
