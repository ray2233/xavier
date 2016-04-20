class PDManager extends Object
{
    var m_nc, m_ns, parent, onMetaData, m_currentPos, m_streamName, m_throwTimeEvents, dispatchEvent, m_timeInterval, m_checkDuration, m_oldTime, m_streamFound, m_streamLength, m_stopping;
    function PDManager(p_nc)
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        this.createStream(p_nc);
    } // End of the function
    function createStream(p_nc)
    {
        m_nc = p_nc;
        m_ns = new NetStream(m_nc);
        m_ns.setBufferTime(5);
        MDReceived = false;
        m_ns.parent = this;
        m_ns.onMetaData = function (mds)
        {
            parent.MDReceived = true;
            parent.m_streamLength = mds.duration;
            parent.dispatchEvent({type: "streamTimeUpdate", percentage: 0});
            parent.dispatchEvent({type: "ready", ns: this});
            if (parent.queuedMD)
            {
                parent.queuedMD = false;
                parent.play();
            } // end if
            onMetaData = null;
        };
        m_currentPos = 0;
        return (m_ns);
    } // End of the function
    function setUp(p_streamName, p_isLive, p_throwTimeEvents, p_bufferTime)
    {
        m_streamName = this.addExtension(p_streamName);
        m_throwTimeEvents = p_throwTimeEvents;
        this.dispatchEvent({type: "ready", ns: this});
    } // End of the function
    function play(Void)
    {
        if (MDReceived)
        {
            if (m_throwTimeEvents)
            {
                m_timeInterval = setInterval(this, "doUpdateTime", 250);
            } // end if
            m_checkDuration = setInterval(this, "checkDuration", 100);
            m_oldTime = -1;
            m_ns.seek(m_currentPos);
            m_ns.pause(false);
        }
        else
        {
            m_streamFound = setInterval(this, "streamFound", 250, 0);
            this.playFirstFrame();
            queuedMD = true;
        } // end else if
    } // End of the function
    function lastOrEnd(isLast)
    {
        clearInterval(m_timeInterval);
        clearInterval(m_checkDuration);
        this.dispatchEvent({type: "buffering", value: false});
        m_currentPos = 0;
        if (!isLast)
        {
            if (!m_playCommandIssued)
            {
                m_ns.play(m_streamName);
                m_playCommandIssued = true;
            }
            else
            {
                m_ns.seek(0);
            } // end if
        } // end else if
        m_ns.seek(isLast ? (m_streamLength) : (0));
        m_ns.pause(true);
    } // End of the function
    function playFirstFrame(Void)
    {
        this.lastOrEnd(false);
    } // End of the function
    function playLastFrame(Void)
    {
        this.lastOrEnd(true);
    } // End of the function
    function pause(p_pause)
    {
        m_ns.pause();
    } // End of the function
    function stop(Void)
    {
        this.playFirstFrame();
    } // End of the function
    function seek(p_percentage, p_state)
    {
        var _loc2 = p_percentage / 100 * m_streamLength;
        m_stopping = false;
        m_currentPos = _loc2;
        m_ns.seek(m_currentPos);
    } // End of the function
    function doUpdateTime(Void)
    {
        this.dispatchEvent({type: "streamTimeUpdate", percentage: m_ns.time / m_streamLength, time: m_ns.time});
    } // End of the function
    function checkDuration(Void)
    {
        if (m_ns.time > 0 && m_ns.time != undefined && m_streamLength > 0 && m_streamLength != undefined && m_streamLength - m_ns.time <= 1)
        {
            if (m_oldTime == m_ns.time)
            {
                m_oldTime = -1;
                this.dispatchEvent({type: "playbackDone"});
            } // end if
        } // end if
        m_oldTime = m_ns.time;
    } // End of the function
    function streamFound(turn)
    {
        clearInterval(m_streamFound);
        if (turn == 3)
        {
            this.dispatchEvent({type: "streamNotFound"});
        }
        else if (!m_ns.bytesTotal)
        {
            m_streamFound = setInterval(this, "streamFound", 250, ++turn);
        } // end else if
    } // End of the function
    function addExtension(n)
    {
        if (n.substr(n.length - 4) == ".flv")
        {
            return (n);
        } // end if
        return (n + ".flv");
    } // End of the function
    var isPaused = false;
    var playedStream = false;
    var m_playCommandIssued = false;
    var MDReceived = false;
    var queuedMD = false;
    var isBuffering = false;
    var k_STOPPED = 0;
    var k_PLAYING = 1;
    var k_PAUSED = 2;
} // End of Class
