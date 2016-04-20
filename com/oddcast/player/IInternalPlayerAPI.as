package com.oddcast.player
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.player.*;
    import flash.display.*;

    public interface IInternalPlayerAPI extends IPublicPlayerAPI
    {

        public function IInternalPlayerAPI();

        function getActiveEngineAPI() : Object;

        function getAudioUrl() : String;

        function getBGHolder() : Sprite;

        function getHostHolder() : Sprite;

        function getShowXML() : XML;

        function initBlankShow() : void;

        function loadBackground(param1:BackgroundStruct) : void;

        function loadHost(param1:HostStruct) : void;

        function loadShowXML(param1:String) : void;

        function loadSkin(param1:SkinStruct) : void;

        function setPlayerInitFlags(param1:int) : void;

        function setSkinConfig(param1:XML) : void;

        function setShowXML(param1:XML) : void;

        function startShow() : void;

        function setSceneAudio(param1:AudioStruct) : void;

        function set3DSceneSize(param1:int, param2:int) : void;

    }
}
