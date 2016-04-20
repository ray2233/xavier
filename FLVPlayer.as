class FLVPlayer extends MovieClip
{
    var m_state, attachMovie, m_rollHandler, m_activelySeeking, m_showingUI, m_pluginsReady, m_pluginManager, m_args, dispatchEvent, mc, m_uiManager, m_skinLoaded, m_hasSeekBar, m_nc, m_nsManager, m_hideUIInterval, m_videoW, m_videoH, m_h, m_w, _parent;
    function FLVPlayer(Void)
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        m_state = k_STOPPED;
        this.attachMovie("RollHandler", "m_rollHandler", 0);
        m_rollHandler._alpha = 0;
        m_activelySeeking = false;
        m_showingUI = true;
        m_pluginsReady = false;
        m_pluginManager = new PluginManager(this);
    } // End of the function
    function pluginsReady(evt)
    {
        m_pluginsReady = true;
        this.setUpStream();
    } // End of the function
    function setUp(p_args)
    {
        m_args = p_args;
        this.dispatchEvent({type: "setUp", target: this, args: m_args});
        this.argsReady();
    } // End of the function
    function argsReady(Void)
    {
        m_args.autoPlay = m_args.autoPlay.toLowerCase() == "true";
        m_args.autoRewind = m_args.autoRewind.toLowerCase() == "true";
        m_args.isFullScreen = m_args.isFullScreen.toLowerCase() == "true";
        m_args.divName = m_args.divName;
        if (m_args.skinName != null)
        {
            this.attachMovie("UIManager", "m_uiManager", 1);
            var _loc2 = new Object();
            _loc2.mc = this;
            _loc2.play = function (p_event)
            {
                mc.uiPlay();
            };
            _loc2.pause = function (p_event)
            {
                mc.uiPause();
            };
            _loc2.stop = function (p_event)
            {
                mc.uiStop();
            };
            _loc2.seek = function (p_event)
            {
                mc.uiSeek(p_event.position);
            };
            _loc2.seekStart = function (p_event)
            {
                mc.uiSeekStart();
            };
            _loc2.rollOver = function (p_event)
            {
                mc.uiRollOver();
            };
            _loc2.onVideoSize = function (p_event)
            {
                mc.uiVideoSize(p_event.w, p_event.h);
            };
            m_uiManager.addEventListener("skinLoaded", this);
            m_uiManager.addEventListener("play", _loc2);
            m_uiManager.addEventListener("pause", _loc2);
            m_uiManager.addEventListener("stop", _loc2);
            m_uiManager.addEventListener("seek", _loc2);
            m_uiManager.addEventListener("seekStart", _loc2);
            m_uiManager.addEventListener("rollOver", _loc2);
            m_uiManager.addEventListener("onVideoSize", _loc2);
            m_uiManager.loadSkin(m_args.skinName, m_args.isLive, m_args.isFullScreen);
        }
        else
        {
            this.error("Missing parameter: skinName");
        } // end else if
        this.dispatchEvent({type: "argsReady", target: this, args: m_args});
    } // End of the function
    function addPlugin(p, pName)
    {
        return (m_pluginManager.addPlugin(p, pName));
    } // End of the function
    function getPlugin(pName)
    {
        return (m_pluginManager.getPlugin(pName));
    } // End of the function
    function removePlugin(pName)
    {
        m_pluginManager.removePlugin(pName);
    } // End of the function
    function skinLoaded(p_event)
    {
        m_skinLoaded = true;
        m_uiManager.setState(m_state);
        m_hasSeekBar = p_event.hasSeekBar;
        if (p_event.autoHide)
        {
            m_rollHandler.useHandCursor = false;
            m_rollHandler.onRollOver = doRollOver;
            m_rollHandler.onRollOut = doRollOut;
        } // end if
        m_uiManager.setSeekPosition(0);
        this.setUpStream();
    } // End of the function
    function uiPlay(Void)
    {
        if (m_nc.isConnected)
        {
            if (m_state == k_STOPPED)
            {
                m_nsManager.play();
            }
            else
            {
                m_nsManager.pause(false);
            } // end else if
            m_state = k_PLAYING;
            m_uiManager.setState(m_state);
        }
        else
        {
            this.dispatchEvent({type: "reconnect", target: this});
        } // end else if
    } // End of the function
    function uiPause(Void)
    {
        m_nsManager.pause(true);
        m_state = k_PAUSED;
        m_uiManager.setState(m_state);
    } // End of the function
    function uiStop(Void)
    {
        if (m_args.autoRewind)
        {
            m_nsManager.stop();
        }
        else
        {
            m_nsManager.playLastFrame();
        } // end else if
        m_state = k_STOPPED;
        m_uiManager.showBuffering(false);
        m_uiManager.setState(m_state);
    } // End of the function
    function uiSeekStart(Void)
    {
        m_activelySeeking = true;
    } // End of the function
    function uiSeek(p_position)
    {
        m_activelySeeking = false;
        m_nsManager.seek(p_position, m_state);
    } // End of the function
    function uiRollOver(Void)
    {
        clearInterval(m_hideUIInterval);
    } // End of the function
    function uiVideoSize(p_w, p_h)
    {
        m_videoW = p_w;
        m_videoH = p_h;
        m_uiManager.setSize(m_w, m_h, m_videoW, m_videoH);
        m_uiManager.showSkin(true);
        var _loc2 = m_uiManager.getPadding();
        this.dispatchEvent({type: "videoSize", w: m_videoW + _loc2.w, h: m_videoH + _loc2.h});
    } // End of the function
    function doRollOver(Void)
    {
        var _loc2 = _parent;
        clearInterval(_loc2.m_hideUIInterval);
        if (!_loc2.m_showingUI)
        {
            _loc2.m_showingUI = true;
            _loc2.m_uiManager.showUI(_loc2.m_showingUI);
        } // end if
    } // End of the function
    function doRollOut(Void)
    {
        var _loc2 = _parent;
        _loc2.m_hideUIInterval = setInterval(_loc2, "hideUI", 200);
    } // End of the function
    function hideUI(Void)
    {
        clearInterval(m_hideUIInterval);
        m_showingUI = false;
        m_uiManager.showUI(m_showingUI);
    } // End of the function
    function ncConnected(evt)
    {
        if (evt.nc == null)
        {
            return;
        } // end if
        m_nc = evt.nc;
        m_args.streamName = this.stripChar(m_args.streamName, " ");
        this.setUpStream();
    } // End of the function
    function setUpStream(Void)
    {
        if (!m_pluginsReady || !m_skinLoaded)
        {
            return;
        } // end if
        if (m_args.streamName != null)
        {
            m_nsManager = new PDManager(m_nc);
            var _loc2 = new Object();
            _loc2.mc = this;
            _loc2.ready = function (p_event)
            {
                mc.nsStreamReady(p_event.ns);
            };
            _loc2.streamTimeUpdate = function (p_event)
            {
                mc.nsTimeUpdate(p_event.percentage, p_event.time);
            };
            _loc2.playbackDone = function (p_event)
            {
                mc.nsDone(p_event.percentage);
            };
            _loc2.streamNotFound = function (p_event)
            {
                mc.nsNotFound();
            };
            _loc2.buffering = function (p_event)
            {
                mc.nsBuffering(p_event.value);
            };
            m_nsManager.addEventListener("ready", _loc2);
            m_nsManager.addEventListener("streamTimeUpdate", _loc2);
            m_nsManager.addEventListener("playbackDone", _loc2);
            m_nsManager.addEventListener("streamNotFound", _loc2);
            m_nsManager.addEventListener("buffering", _loc2);
            m_nsManager.setUp(m_args.streamName, m_args.isLive, m_hasSeekBar || m_args.queuePointsFile != undefined, m_args.bufferTime);
        }
        else
        {
            this.error("Missing parameter: streamName");
        } // end else if
    } // End of the function
    function nsStreamReady(p_ns)
    {
        m_uiManager.attachStream(p_ns);
        if (m_args.autoPlay)
        {
            this.uiPlay();
        }
        else
        {
            m_nsManager.playFirstFrame();
            m_uiManager.setSeekPosition(0);
        } // end else if
        m_uiManager.adjustVideoSize();
        this.dispatchEvent({type: "nsStreamReady", target: this});
    } // End of the function
    function nsTimeUpdate(p_percentage, p_seconds)
    {
        if (!m_activelySeeking)
        {
            m_uiManager.setSeekPosition(p_percentage);
        } // end if
        this.dispatchEvent({type: "nsTimeUpdate", target: this, seconds: p_seconds, percentage: p_percentage});
    } // End of the function
    function nsDone(Void)
    {
        this.uiStop();
        if (m_args.autoRewind)
        {
            m_uiManager.setSeekPosition(0);
            m_nsManager.playFirstFrame();
        } // end if
        this.dispatchEvent({type: "done"});
    } // End of the function
    function nsNotFound(Void)
    {
        this.uiStop();
        m_uiManager.stopAdjustVideoSize();
        this.dispatchEvent({type: "nsNotFound", target: this});
        this.dispatchEvent({type: "tryFallBack", target: this});
    } // End of the function
    function nsBuffering(p_show)
    {
        m_uiManager.showBuffering(p_show);
        this.dispatchEvent({type: "nsBuffering", target: this});
    } // End of the function
    function setSize(p_w, p_h)
    {
        m_w = p_w;
        m_h = p_h;
        m_rollHandler._width = m_w;
        m_rollHandler._height = m_h;
        m_uiManager.setSize(m_w, m_h, m_videoW, m_videoH);
    } // End of the function
    function error(p_msg)
    {
        trace ("ERROR:" + p_msg);
    } // End of the function
    function stripChar(p_str, p_char)
    {
        return (p_str.split(p_char).join(""));
    } // End of the function
    var k_STOPPED = 0;
    var k_PLAYING = 1;
    var k_PAUSED = 2;
} // End of Class
