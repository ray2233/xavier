class UIManager extends MovieClip
{
    var m_isMuted, m_sound, m_soundLevel, m_showBuffering, m_showUI, currentSkinMovie, m_isLive, createEmptyMovieClip, m_skin, m_counter, m_mustLoadSkin, onEnterFrame, m_v, m_mustCheckVideoSize, dispatchEvent, m_skinInfo, up_mc, over_mc, down_mc, mc, _parent, startX, _width, _x, startY, type, _height, _y, height, m_isFullScreen, m_state, m_videoH, m_videoW, m_h, m_w, m_id, disabled_mc, onRollOver, onRollOut, onPress, onRelease, onReleaseOutside, m_cachedSoundLevel, m_percentage, m_ns, attachAudio;
    function UIManager(Void)
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        m_isMuted = false;
        m_sound = new Sound(this);
        m_soundLevel = 50;
        m_showBuffering = false;
        m_showUI = true;
    } // End of the function
    function loadSkin(p_skin, p_isLive)
    {
        currentSkinMovie = p_skin;
        m_isLive = p_isLive;
        this.createEmptyMovieClip("m_skin", 0);
        m_skin.loadMovie(p_skin + ".swf");
        m_counter = 0;
        m_mustLoadSkin = true;
        onEnterFrame = doEnterFrame;
    } // End of the function
    function doEnterFrame(Void)
    {
        if (m_mustLoadSkin)
        {
            ++m_counter;
            var _loc2 = m_skin.getBytesLoaded() / m_skin.getBytesTotal();
            if (_loc2 == 1)
            {
                m_mustLoadSkin = false;
                this.onSkinLoaded();
            }
            else if (_loc2 == 0 && m_counter == 50)
            {
                m_skin.loadMovie(currentSkinMovie + ".swf");
                m_counter = 0;
            } // end else if
        }
        else
        {
            var _loc4 = m_v.width;
            var _loc3 = m_v.height;
            if (_loc4 != 0)
            {
                m_mustCheckVideoSize = false;
                this.dispatchEvent({type: "onVideoSize", w: _loc4, h: _loc3});
            } // end if
        } // end else if
        if (!m_mustLoadSkin && !m_mustCheckVideoSize)
        {
            delete this.onEnterFrame;
        } // end if
    } // End of the function
    function onSkinLoaded(Void)
    {
        m_skinInfo = m_skin.getSkinInfo();
        m_skin._visible = false;
        if (!m_isLive)
        {
            if (m_skin.play_mc)
            {
                this.fixUp("play_mc");
            }
            else
            {
                this.myTrace("BROKEN SKIN: no play button");
            } // end else if
            if (m_skin.pause_mc)
            {
                this.fixUp("pause_mc");
            }
            else
            {
                this.myTrace("BROKEN SKIN: no pause button");
            } // end else if
            if (m_skinInfo.mode == undefined)
            {
                m_skinInfo.mode = "hide";
            } // end if
            if (m_skin.seekBar_mc)
            {
                var _loc9 = m_skin.seekBar_mc;
                _loc9.left_mc._x = _loc9.left_mc._y = 0;
                _loc9.middle_mc._x = _loc9.middle_mc._y = 0;
                _loc9.right_mc._x = _loc9.right_mc._y = 0;
                var _loc4 = _loc9.handle_mc;
                _loc4._x = _loc4._y = 0;
                _loc9 = _loc4.up_mc;
                _loc9._x = _loc9._y = 0;
                _loc9 = _loc4.over_mc;
                _loc9._x = _loc9._y = 0;
                _loc9._visible = false;
                _loc9 = _loc4.down_mc;
                _loc9._x = _loc9._y = 0;
                _loc9._visible = false;
                _loc4.mc = this;
                _loc4.onRollOver = function ()
                {
                    up_mc._visible = false;
                    over_mc._visible = true;
                    down_mc._visible = false;
                    if (mc.m_skinInfo.autoHide)
                    {
                        mc.dispatchEvent({type: "rollOver"});
                    } // end if
                };
                _loc4.onRollOut = function ()
                {
                    up_mc._visible = true;
                    over_mc._visible = false;
                    down_mc._visible = false;
                    delete this.onMouseMove;
                };
                _loc4.onPress = function ()
                {
                    up_mc._visible = false;
                    over_mc._visible = false;
                    down_mc._visible = true;
                    mc.dispatchEvent({type: "seekStart"});
                    startX = _parent._x;
                    function onMouseMove()
                    {
                        _x = Math.round(_root._xmouse - startX - _width / 2);
                        var _loc3 = Math.round(_parent.middle_mc._x - _width / 2);
                        if (_x < _loc3)
                        {
                            _x = _loc3;
                        } // end if
                        _loc3 = Math.round(_parent.right_mc._x - _width / 2);
                        if (_x > _loc3)
                        {
                            _x = _loc3;
                        } // end if
                    } // End of the function
                };
                _loc4.onRelease = function ()
                {
                    up_mc._visible = false;
                    over_mc._visible = true;
                    down_mc._visible = false;
                    delete this.onMouseMove;
                    var _loc2 = Math.round((_x - (_parent.middle_mc._x - _width / 2)) * 100 / _parent.middle_mc._width);
                    mc.dispatchEvent({type: "seek", position: _loc2});
                };
                _loc4.onReleaseOutside = function ()
                {
                    up_mc._visible = true;
                    over_mc._visible = false;
                    down_mc._visible = false;
                    delete this.onMouseMove;
                    var _loc2 = Math.round((_x - (_parent.middle_mc._x - _width / 2)) * 100 / _parent.middle_mc._width);
                    mc.dispatchEvent({type: "seek", position: _loc2});
                };
            } // end if
            if (m_skin.stop_mc)
            {
                this.fixUp("stop_mc");
            } // end if
        }
        else
        {
            m_skin.play_mc._visible = false;
            m_skin.pause_mc._visible = false;
            m_skin.seekBar_mc._visible = false;
            m_skin.stop_mc._visible = false;
        } // end else if
        if (m_skin.cover_mc)
        {
            _loc9 = m_skin.cover_mc;
            _loc9._x = _loc9._y = 0;
        } // end if
        if (m_skin.volumeBar_mc)
        {
            _loc9 = m_skin.volumeBar_mc;
            var _loc7 = m_skinInfo.volumeBar;
            _loc4 = _loc9.handle_mc;
            _loc4._x = _loc4._y = 0;
            _loc9 = _loc4.up_mc;
            _loc9._x = _loc9._y = 0;
            _loc9 = _loc4.over_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc4.down_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc4.mc = this;
            _loc4.type = _loc7.type;
            _loc4.onRollOver = function ()
            {
                up_mc._visible = false;
                over_mc._visible = true;
                down_mc._visible = false;
                if (mc.m_skinInfo.autoHide)
                {
                    mc.dispatchEvent({type: "rollOver"});
                } // end if
            };
            _loc4.onRollOut = function ()
            {
                up_mc._visible = true;
                over_mc._visible = false;
                down_mc._visible = false;
                delete this.onMouseMove;
            };
            _loc4.onPress = function ()
            {
                trace ("onPress!");
                up_mc._visible = false;
                over_mc._visible = false;
                down_mc._visible = true;
                startX = _parent._x;
                startY = _parent._y;
                mc.setMuteStatus(false);
                function onMouseMove()
                {
                    if (type == "horizontal")
                    {
                        _x = Math.round(_root._xmouse - startX - _width / 2);
                        var _loc3 = Math.round(_parent.bar_mc._x - _width / 2);
                        if (_x < _loc3)
                        {
                            _x = _loc3;
                        } // end if
                        _loc3 = Math.round(_parent.bar_mc._width - _width / 2);
                        if (_x > _loc3)
                        {
                            _x = _loc3;
                        } // end if
                        var _loc4 = Math.round((_x + _width / 2 - _parent.bar_mc._x) * 100 / _parent.bar_mc._width);
                    }
                    else
                    {
                        _y = Math.round(_root._ymouse - startY - _height / 2);
                        _loc3 = Math.round(_parent.bar_mc._y + height / 2);
                        if (_y < _loc3)
                        {
                            _y = _loc3;
                        } // end if
                        _loc3 = Math.round(_parent.bar_mc._height - _height / 2);
                        if (_y > _loc3)
                        {
                            _y = _loc3;
                        } // end if
                        _loc4 = 100 - Math.round((_y - _parent.bar_mc._y) * 100 / (_parent.bar_mc._height - _height));
                    } // end else if
                    mc.setSoundLevel(_loc4);
                } // End of the function
            };
            _loc4.onRelease = function ()
            {
                up_mc._visible = false;
                over_mc._visible = true;
                down_mc._visible = false;
                delete this.onMouseMove;
            };
            _loc4.onReleaseOutside = function ()
            {
                up_mc._visible = true;
                over_mc._visible = false;
                down_mc._visible = false;
                delete this.onMouseMove;
            };
            this.setSoundLevel(m_soundLevel);
        } // end if
        if (m_skin.volumeMute_mc)
        {
            var _loc10 = m_skin.volumeMute_mc;
            var _loc5 = _loc10.on_mc;
            _loc5._x = _loc5._y = 0;
            var _loc3 = _loc10.off_mc;
            _loc3._x = _loc3._y = 0;
            _loc9 = _loc5.up_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = true;
            _loc9 = _loc5.over_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc5.down_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc3.up_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = true;
            _loc9 = _loc3.over_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc3.down_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc5._visible = !m_isMuted;
            _loc5.mc = this;
            _loc5.onRollOver = doRollOver;
            _loc5.onRollOut = doRollOut;
            _loc5.onPress = doPress;
            _loc5.onRelease = doReleaseVolumeMute;
            _loc5.onReleaseOutside = doRollOut;
            _loc3._visible = m_isMuted;
            _loc3.mc = this;
            _loc3.onRollOver = doRollOver;
            _loc3.onRollOut = doRollOut;
            _loc3.onPress = doPress;
            _loc3.onRelease = doReleaseVolumeMute;
            _loc3.onReleaseOutside = doRollOut;
        } // end if
        if (m_skin.fullScreen_mc)
        {
            _loc10 = m_skin.fullScreen_mc;
            var _loc6 = _loc10.minimize_mc;
            _loc6._x = _loc6._y = 0;
            var _loc8 = _loc10.maximize_mc;
            _loc8._x = _loc8._y = 0;
            _loc9 = _loc6.up_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = true;
            _loc9 = _loc6.over_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc6.down_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc8.up_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc8.over_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc9 = _loc8.down_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
            _loc6._visible = m_isFullScreen;
            _loc6.mc = this;
        } // end if
        if (m_skin.buffering_mc)
        {
            _loc9 = m_skin.buffering_mc;
            _loc9._x = _loc9._y = 0;
            _loc9._visible = false;
        } // end if
        this.setState(m_state);
        this.setSize(m_w, m_h, m_videoW, m_videoH);
        this.dispatchEvent({type: "skinLoaded", hasSeekBar: m_skin.seekBar_mc != undefined, autoHide: m_skinInfo.autoHide == true});
    } // End of the function
    function showSkin(p_show)
    {
        m_skin._visible = p_show;
    } // End of the function
    function fixUp(p_mc)
    {
        var _loc2 = m_skin[p_mc].up_mc;
        _loc2._x = _loc2._y = 0;
        _loc2._visible = true;
        _loc2 = m_skin[p_mc].over_mc;
        _loc2._x = _loc2._y = 0;
        _loc2._visible = false;
        _loc2 = m_skin[p_mc].down_mc;
        _loc2._x = _loc2._y = 0;
        _loc2._visible = false;
        _loc2 = m_skin[p_mc].disabled_mc;
        _loc2._x = _loc2._y = 0;
        _loc2._visible = false;
        _loc2 = m_skin[p_mc];
        _loc2.m_id = p_mc;
        _loc2.mc = this;
        _loc2.onRollOver = doRollOver;
        _loc2.onRollOut = doRollOut;
        _loc2.onPress = doPress;
        _loc2.onRelease = doRelease;
        _loc2.onReleaseOutside = doRollOut;
        _loc2.setEnabled = doSetEnabled;
    } // End of the function
    function showUI(p_show)
    {
        m_showUI = p_show;
        this.setState(m_state);
    } // End of the function
    function setBgColor(p_bgColor)
    {
    } // End of the function
    function adjustVideoSize(Void)
    {
        m_mustCheckVideoSize = true;
        onEnterFrame = doEnterFrame;
    } // End of the function
    function stopAdjustVideoSize(Void)
    {
        delete this.onEnterFrame;
    } // End of the function
    function doRollOver(Void)
    {
        up_mc._visible = false;
        over_mc._visible = true;
        if (mc.m_skinInfo.autoHide)
        {
            mc.dispatchEvent({type: "rollOver"});
        } // end if
    } // End of the function
    function doRollOut(Void)
    {
        over_mc._visible = false;
        down_mc._visible = false;
        up_mc._visible = true;
    } // End of the function
    function doPress(Void)
    {
        over_mc._visible = false;
        down_mc._visible = true;
    } // End of the function
    function doRelease(Void)
    {
        down_mc._visible = false;
        over_mc._visible = true;
        var _loc2 = mc;
        switch (m_id)
        {
            case "play_mc":
            {
                _loc2.dispatchEvent({type: "play"});
                break;
            } 
            case "pause_mc":
            {
                _loc2.showBuffering(false);
                _loc2.dispatchEvent({type: "pause"});
                break;
            } 
            case "stop_mc":
            {
                _loc2.showBuffering(false);
                _loc2.setSeekPosition(0);
                _loc2.dispatchEvent({type: "stop"});
                break;
            } 
        } // End of switch
    } // End of the function
    function doSetEnabled(p_enabled)
    {
        if (p_enabled)
        {
            up_mc._visible = true;
            down_mc._visible = false;
            over_mc._visible = false;
            disabled_mc._visible = false;
            var _loc2 = mc;
            onRollOver = _loc2.doRollOver;
            onRollOut = _loc2.doRollOut;
            onPress = _loc2.doPress;
            onRelease = _loc2.doRelease;
            onReleaseOutside = _loc2.doRollOut;
        }
        else
        {
            up_mc._visible = false;
            down_mc._visible = false;
            over_mc._visible = false;
            disabled_mc._visible = true;
            delete this.onRollOver;
            delete this.onRollOut;
            delete this.onPress;
            delete this.onRelease;
            delete this.onReleaseOutside;
        } // end else if
    } // End of the function
    function doReleaseVolumeMute(Void)
    {
        down_mc._visible = false;
        over_mc._visible = true;
        var _loc2 = _parent._parent._parent;
        _loc2.toggleMuted();
    } // End of the function
    function toggleMuted(Void)
    {
        this.setMuteStatus(!m_isMuted);
        if (m_isMuted)
        {
            m_cachedSoundLevel = m_soundLevel;
            this.setSoundLevel(0);
        }
        else
        {
            this.setSoundLevel(m_cachedSoundLevel);
        } // end else if
    } // End of the function
    function setMuteStatus(p_muted)
    {
        m_isMuted = p_muted;
        this.myTrace("toggleMuted:" + m_isMuted + "/" + m_soundLevel);
        var _loc2 = m_skin.volumeMute_mc;
        var _loc4 = _loc2.on_mc;
        var _loc3 = _loc2.off_mc;
        _loc4._visible = !m_isMuted;
        _loc3._visible = m_isMuted;
        m_sound.setVolume(m_isMuted ? (0) : (m_soundLevel));
    } // End of the function
    function doReleaseFullScreen(Void)
    {
        down_mc._visible = false;
        var _loc2 = _parent._parent._parent;
        _loc2.m_isFullScreen = !_loc2.m_isFullScreen;
        _loc2.dispatchEvent({type: "fullScreen", goToFullScreen: _loc2.m_isFullScreen});
        _loc2.m_skin.fullScreen_mc.minimize_mc._visible = false;
        _loc2.m_skin.fullScreen_mc.maximize_mc._visible = false;
        var _loc3 = _loc2.m_isFullScreen ? (_loc2.m_skin.fullScreen_mc.minimize_mc) : (_loc2.m_skin.fullScreen_mc.maximize_mc);
        _loc3._visible = true;
        _loc3.up_mc._visible = false;
        _loc3.down_mc._visible = false;
        _loc3.over_mc._visible = true;
    } // End of the function
    function setSeekPosition(p_percentage)
    {
        m_percentage = p_percentage;
        if (m_isLive || !m_skin.seekBar_mc)
        {
            return;
        } // end if
        var _loc2 = m_skin.seekBar_mc;
        _loc2.handle_mc._x = Math.round(_loc2.middle_mc._x + _loc2.middle_mc._width * p_percentage - _loc2.handle_mc._width / 2);
    } // End of the function
    function setSoundLevel(p_percentage)
    {
        if (!m_skin.volumeBar_mc)
        {
            return;
        } // end if
        var _loc2 = m_skin.volumeBar_mc;
        var _loc4 = m_skinInfo.volumeBar;
        m_soundLevel = p_percentage;
        m_sound.setVolume(m_isMuted ? (0) : (p_percentage));
        this.setMuteStatus(p_percentage == 0);
        if (_loc4.type == "horizontal")
        {
            _loc2.handle_mc._x = Math.round(_loc2.bar_mc._x - _loc2.handle_mc._width / 2 + _loc2.bar_mc._width * p_percentage / 100);
        }
        else
        {
            _loc2.handle_mc._y = Math.round(_loc2.bar_mc._y - _loc2.handle_mc._height / 2 + _loc2.bar_mc._height * (100 - p_percentage) / 100);
        } // end else if
    } // End of the function
    function getPadding(Void)
    {
        if (m_skin.cover_mc)
        {
            var _loc2 = m_skin.cover_mc;
            return ({w: Math.round(_loc2.w_mc._width + _loc2.e_mc._width), h: Math.round(_loc2.n_mc._height + _loc2.s_mc._height)});
        }
        else
        {
            return ({w: 0, h: 0});
        } // end else if
    } // End of the function
    function setState(p_state)
    {
        m_state = p_state;
        if (!m_isLive)
        {
            if (m_skinInfo.mode == "hide")
            {
                m_skin.play_mc._visible = m_state == k_STOPPED || m_state == k_PAUSED;
                m_skin.pause_mc._visible = m_state == k_PLAYING;
                m_skin.stop_mc._visible = (m_state == k_PLAYING || m_state == k_PAUSED) && !m_skin.seekBar_mc;
            }
            else
            {
                m_skin.play_mc._visible = true;
                m_skin.play_mc.setEnabled(m_state == k_STOPPED || m_state == k_PAUSED);
                m_skin.pause_mc._visible = true;
                m_skin.pause_mc.setEnabled(m_state == k_PLAYING);
                m_skin.stop_mc._visible = true;
                m_skin.stop_mc.setEnabled(m_state == k_PLAYING || m_state == k_PAUSED);
            } // end else if
            m_skin.play_mc._visible = m_skin.play_mc._visible && m_showUI;
            m_skin.pause_mc._visible = m_skin.pause_mc._visible && m_showUI;
            m_skin.stop_mc._visible = m_skin.stop_mc._visible && m_showUI;
            m_skin.seekBar_mc._visible = m_showUI;
        } // end if
        m_skin.volumeMute_mc._visible = m_showUI;
        m_skin.volumeBar_mc._visible = m_showUI;
        m_skin.buffering_mc._visible = m_showBuffering && m_showUI;
        m_skin.fullScreen_mc._visible = m_showUI;
    } // End of the function
    function attachStream(p_ns)
    {
        m_ns = p_ns;
        m_v.attachVideo(p_ns);
        this.attachAudio(m_ns);
        m_sound.setVolume(m_isMuted ? (0) : (m_soundLevel));
    } // End of the function
    function showBuffering(p_show)
    {
        if (m_skin.buffering_mc)
        {
            m_showBuffering = p_show;
        }
        else
        {
            m_showBuffering = false;
        } // end else if
        m_skin.buffering_mc._visible = m_showBuffering && m_showUI;
    } // End of the function
    function setSize(p_w, p_h, p_videoW, p_videoH)
    {
        if (p_videoW == undefined)
        {
            return;
        } // end if
        m_w = p_w;
        m_h = p_h;
        m_videoW = p_videoW;
        m_videoH = p_videoH;
        var _loc5 = 0;
        var _loc4 = 0;
        var _loc2 = Math.round(m_w);
        var _loc3 = Math.round(m_h);
        if (m_skinInfo.uiMode == "center")
        {
            _loc5 = (m_w - m_videoW) / 2;
            _loc4 = (m_h - m_videoH) / 2;
            _loc2 = m_videoW;
            _loc3 = m_videoH;
        }
        else if (m_skinInfo.uiMode == "TL")
        {
            _loc2 = m_videoW;
            _loc3 = m_videoH;
        }
        else
        {
            var _loc7 = this.getPadding();
            var _loc21 = (m_videoW + _loc7.w) / (m_videoH + _loc7.h);
            if (m_w / m_h > _loc21)
            {
                _loc3 = m_h;
                _loc2 = _loc3 * _loc21;
                _loc5 = (m_w - _loc2) / 2;
                _loc4 = 0;
            }
            else
            {
                _loc2 = m_w;
                _loc3 = _loc2 / _loc21;
                _loc5 = 0;
                _loc4 = (m_h - _loc3) / 2;
            } // end else if
        } // end else if
        if (m_skinInfo.video)
        {
            var _loc19 = m_skinInfo.video;
            m_v._x = Math.round((_loc19.x >= 0 ? (_loc19.x) : (_loc2 + _loc19.w)) + _loc5);
            m_v._y = Math.round((_loc19.y >= 0 ? (_loc19.y) : (_loc3 + _loc19.h)) + _loc4);
            m_v._width = Math.round(_loc19.w > 0 ? (_loc19.w) : (_loc2 + _loc19.w));
            m_v._height = Math.round(_loc19.h > 0 ? (_loc19.h) : (_loc3 + _loc19.h));
        }
        else
        {
            m_v._x = Math.round(_loc5);
            m_v._y = Math.round(_loc4);
            m_v._width = Math.round(_loc2);
            m_v._height = Math.round(_loc3);
        } // end else if
        m_skin._width = Math.round(m_w);
        m_skin._height = Math.round(m_h);
        m_skin._xscale = 100;
        m_skin._yscale = 100;
        var _loc15;
        _loc15 = m_skinInfo.playBtn.x;
        m_skin.play_mc._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
        _loc15 = m_skinInfo.playBtn.y;
        m_skin.play_mc._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
        _loc15 = m_skinInfo.pauseBtn.x;
        m_skin.pause_mc._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
        _loc15 = m_skinInfo.pauseBtn.y;
        m_skin.pause_mc._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
        if (m_skin.stop_mc)
        {
            _loc15 = m_skinInfo.stopBtn.x;
            m_skin.stop_mc._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
            _loc15 = m_skinInfo.stopBtn.y;
            m_skin.stop_mc._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
        } // end if
        if (m_skin.volumeMute_mc)
        {
            _loc15 = m_skinInfo.volumeMute.x;
            m_skin.volumeMute_mc._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
            _loc15 = m_skinInfo.volumeMute.y;
            m_skin.volumeMute_mc._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
        } // end if
        if (m_skin.fullScreen_mc)
        {
            _loc15 = m_skinInfo.fullScreenBtn.x;
            m_skin.fullScreen_mc._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
            _loc15 = m_skinInfo.fullScreenBtn.y;
            m_skin.fullScreen_mc._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
        } // end if
        if (m_skin.cover_mc)
        {
            _loc7 = m_skin.cover_mc;
            var _loc12 = _loc7.nw_mc;
            var _loc20 = _loc7.n_mc;
            var _loc10 = _loc7.ne_mc;
            var _loc16 = _loc7.e_mc;
            var _loc11 = _loc7.se_mc;
            var _loc17 = _loc7.s_mc;
            var _loc9 = _loc7.sw_mc;
            var _loc22 = _loc7.w_mc;
            _loc12._x = Math.round(_loc5);
            _loc12._y = Math.round(_loc4);
            _loc20._x = Math.round(_loc12._width + _loc5);
            _loc20._y = Math.round(_loc4);
            _loc20._width = Math.round(_loc2 - _loc12._width - _loc10._width);
            _loc10._x = Math.round(_loc2 - _loc10._width + _loc5);
            _loc10._y = Math.round(_loc4);
            _loc16._x = Math.round(_loc2 - _loc16._width + _loc5);
            _loc16._y = Math.round(_loc10._height + _loc4);
            _loc16._height = Math.round(_loc3 - _loc10._height - _loc11._height);
            _loc11._x = Math.round(_loc2 - _loc11._width + _loc5);
            _loc11._y = Math.round(_loc3 - _loc11._height + _loc4);
            _loc17._x = Math.round(_loc9._width + _loc5);
            _loc17._y = Math.round(_loc3 - _loc17._height + _loc4);
            _loc17._width = Math.round(_loc2 - _loc9._width - _loc11._width);
            _loc9._x = Math.round(_loc5);
            _loc9._y = Math.round(_loc3 - _loc9._height + _loc4);
            _loc22._x = Math.round(_loc5);
            _loc22._y = Math.round(_loc12._height + _loc4);
            _loc22._height = Math.round(_loc3 - _loc12._height - _loc9._height);
        } // end if
        if (m_skin.volumeBar_mc)
        {
            _loc19 = m_skin.volumeBar_mc;
            var _loc14 = _loc19.handle_mc;
            var _loc8 = _loc19.bar_mc;
            _loc15 = m_skinInfo.volumeBar;
            _loc19._x = Math.round((_loc15.x >= 0 ? (_loc15.x) : (_loc2 + _loc15.x)) + _loc5);
            _loc19._y = Math.round((_loc15.y >= 0 ? (_loc15.y) : (_loc3 + _loc15.y)) + _loc4);
            if (_loc15.type == "horizontal")
            {
                _loc8._width = Math.round(_loc15.l > 0 ? (_loc15.l) : (_loc2 + _loc15.l));
                _loc8._x = 0;
                _loc8._y = Math.round((_loc14._height - _loc8._height) / 2);
                _loc14._y = 0;
            }
            else
            {
                _loc8._height = Math.round(_loc15.l > 0 ? (_loc15.l) : (_loc3 + _loc15.l));
                _loc8._x = Math.round((_loc14._width - _loc8._width) / 2);
                _loc8._y = 0;
                _loc14._x = 0;
            } // end if
        } // end else if
        if (m_skin.seekBar_mc)
        {
            _loc19 = m_skin.seekBar_mc;
            var _loc13 = _loc19.left_mc;
            var _loc6 = _loc19.middle_mc;
            var _loc18 = _loc19.right_mc;
            _loc14 = _loc19.handle_mc;
            _loc15 = m_skinInfo.seekBar.x;
            _loc19._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
            _loc15 = m_skinInfo.seekBar.y;
            _loc19._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
            if (_loc14._height > _loc6._height)
            {
                _loc14._y = 0;
                _loc6._y = Math.round((_loc14._height - _loc6._height) / 2);
            }
            else
            {
                _loc6._y = 0;
                _loc14._y = Math.round((_loc6._height - _loc14._height) / 2);
            } // end else if
            _loc13._x = 0;
            _loc13._y = Math.round(_loc6._y);
            _loc6._x = Math.round(_loc13._x + _loc13._width);
            _loc15 = m_skinInfo.seekBar.w;
            _loc6._width = Math.round((_loc15 > 0 ? (_loc15) : (_loc2 + _loc15)) - _loc13._width - _loc18._width);
            _loc18._x = Math.round(_loc6._x + _loc6._width);
            _loc18._y = Math.round(_loc6._y);
            this.setSeekPosition(m_percentage);
        } // end if
        if (m_skin.buffering_mc)
        {
            _loc19 = m_skin.buffering_mc;
            _loc15 = m_skinInfo.buffering.x;
            _loc19._x = Math.round((_loc15 >= 0 ? (_loc15) : (_loc2 + _loc15)) + _loc5);
            _loc15 = m_skinInfo.buffering.y;
            _loc19._y = Math.round((_loc15 >= 0 ? (_loc15) : (_loc3 + _loc15)) + _loc4);
            _loc15 = m_skinInfo.buffering.w;
            if (_loc15)
            {
                _loc19._width = Math.round(_loc15 > 0 ? (_loc15) : (_loc2 + _loc15));
            } // end if
        } // end if
    } // End of the function
    function myTrace(p_msg)
    {
        trace ("#UIManager# " + p_msg);
    } // End of the function
    var k_STOPPED = 0;
    var k_PLAYING = 1;
    var k_PAUSED = 2;
} // End of Class
