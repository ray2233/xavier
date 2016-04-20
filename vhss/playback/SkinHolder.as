package vhss.playback
{
    import com.oddcast.assets.structures.*;
    import com.oddcast.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class SkinHolder extends AssetHolder
    {
        private var active_skin:MovieClip;
        private var skin_volume:Number = 1;

        public function SkinHolder(param1:String = "skin") : void
        {
            super(param1);
            return;
        }// end function

        override public function displayAsset(param1:LoadedAssetStruct) : void
        {
            super.displayAsset(param1);
            if (param1 == null || param1.url == null)
            {
                active_skin = null;
            }
            else
            {
                active_skin = MovieClip(active_asset_data.display_obj);
                active_skin.addEventListener(SkinEvent.PLAY, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.LEAD_ERROR, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.LEAD_SUCCESS, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.MUTE, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.NEXT, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.PREV, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.SAY_AI, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.SAY_FAQ, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.SEND_LEAD, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.PAUSE, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.UNMUTE, e_dispatchEvent);
                active_skin.addEventListener(SkinEvent.VOLUME_CHANGE, e_dispatchEvent);
                setVolumeSlider(skin_volume);
            }
            return;
        }// end function

        override protected function removeActiveAsset() : void
        {
            var _loc_1:MovieClip = null;
            if (active_asset_data != null && active_asset_data.display_obj != null)
            {
                _loc_1 = MovieClip(active_asset_data.display_obj);
                _loc_1.removeEventListener(SkinEvent.PLAY, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.LEAD_ERROR, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.LEAD_SUCCESS, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.MUTE, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.NEXT, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.PREV, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.SAY_AI, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.SAY_FAQ, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.SEND_LEAD, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.PAUSE, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.UNMUTE, e_dispatchEvent);
                _loc_1.removeEventListener(SkinEvent.VOLUME_CHANGE, e_dispatchEvent);
            }
            super.removeActiveAsset();
            return;
        }// end function

        override protected function getLoaderContext(param1:LoadedAssetStruct) : LoaderContext
        {
            var _loc_2:* = new LoaderContext();
            if (param1.url.indexOf(".swf") == -1)
            {
                _loc_2.checkPolicyFile = true;
            }
            _loc_2.applicationDomain = new ApplicationDomain();
            return _loc_2;
        }// end function

        public function configureSkin(param1:XML) : void
        {
            active_skin.configureSkin(param1);
            return;
        }// end function

        public function activatePlayButton() : void
        {
            if (active_skin != null)
            {
                active_skin.talkEnded();
            }
            return;
        }// end function

        public function activatePauseButton() : void
        {
            if (active_skin != null)
            {
                active_skin.talkStarted();
            }
            return;
        }// end function

        public function getWatermarkPosition() : Object
        {
            return active_skin.getWatermarkPosition();
        }// end function

        public function activateMuteButton() : void
        {
            return;
        }// end function

        public function activateUnmuteButton() : void
        {
            return;
        }// end function

        public function setAIResponse(param1:String) : void
        {
            if (active_skin != null)
            {
                active_skin.setAIResponse(param1);
            }
            return;
        }// end function

        public function setVolumeSlider(param1:Number) : void
        {
            skin_volume = param1;
            if (active_skin != null)
            {
                active_skin.setVolume(skin_volume);
            }
            return;
        }// end function

        public function getSkinMask() : MovieClip
        {
            return MovieClip(active_skin.getChildByName("mask"));
        }// end function

        public function setLeadResponse(param1:Boolean) : void
        {
            active_skin.onLeadResponse(param1);
            return;
        }// end function

        override public function destroy() : void
        {
            var _loc_1:Object = null;
            var _loc_2:LoadedAssetStruct = null;
            var _loc_3:MovieClip = null;
            var _loc_4:LoaderInfo = null;
            removeActiveAsset();
            for each (_loc_1 in stack)
            {
                
                if (_loc_1 && _loc_1 is LoadedAssetStruct)
                {
                    _loc_2 = LoadedAssetStruct(_loc_1);
                    _loc_3 = MovieClip(_loc_2.display_obj);
                    _loc_3.removeEventListener(SkinEvent.PLAY, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.LEAD_ERROR, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.LEAD_SUCCESS, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.MUTE, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.NEXT, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.PREV, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.SAY_AI, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.SAY_FAQ, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.SEND_LEAD, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.PAUSE, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.UNMUTE, e_dispatchEvent);
                    _loc_3.removeEventListener(SkinEvent.VOLUME_CHANGE, e_dispatchEvent);
                    if (_loc_2.loader.contentLoaderInfo)
                    {
                        _loc_4 = _loc_2.loader.contentLoaderInfo;
                        _loc_4.removeEventListener(Event.INIT, e_initHandler);
                        _loc_4.removeEventListener(HTTPStatusEvent.HTTP_STATUS, e_httpStatusHandler);
                        _loc_4.removeEventListener(Event.COMPLETE, e_completeHandler);
                        _loc_4.removeEventListener(IOErrorEvent.IO_ERROR, e_ioErrorHandler);
                        _loc_4.removeEventListener(Event.OPEN, e_openHandler);
                        _loc_4.removeEventListener(ProgressEvent.PROGRESS, e_progressHandler);
                        _loc_4.removeEventListener(Event.UNLOAD, e_unLoadHandler);
                    }
                    _loc_2.loader.unload();
                    _loc_2.loader = null;
                    _loc_2.display_obj = null;
                }
            }
            return;
        }// end function

        private function e_dispatchEvent(param1) : void
        {
            var _loc_2:* = new SkinEvent(param1.type, param1.obj);
            dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
