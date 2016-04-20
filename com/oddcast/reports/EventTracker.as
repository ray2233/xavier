package com.oddcast.reports
{
    import com.oddcast.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class EventTracker extends Object
    {
        private var req_domain:String = "http://track.oddcast.com/event.php";
        private var send_frequency:Number = 2000;
        private var sendTimer:Timer;
        private var max_so_size:Number = 10000;
        private var session_end:Number = 1200000;
        private var app_type:String;
        private var account_id:String;
        private var show_id:String;
        private var skin_id:String;
        private var scene_id:String;
        private var partner_id:String;
        private var app_id:String;
        private var email_session:String;
        private var embed_session:String;
        private var swf_name:String;
        private var page_domain:String;
        private var so:OddcastSharedObject;
        private var so_data:Object;
        private var unique:Number;
        private var eventtime:Date;
        private var events:Object;
        private var init_obj:Object;
        private var session_event_map:SessionEventMap;

        public function EventTracker()
        {
            return;
        }// end function

        public function init(param1:String, param2:Object, param3:LoaderInfo = null) : void
        {
            var t_regex:RegExp;
            var t_swf_url:String;
            var t_so_date:Date;
            var t_so_data:Object;
            var in_req_url:* = param1;
            var in_init_obj:* = param2;
            var in_loader:* = param3;
            if (in_req_url != null)
            {
                req_domain = in_req_url;
            }
            if (in_init_obj == null)
            {
                in_init_obj = new Object();
            }
            init_obj = in_init_obj;
            if (in_init_obj["apt"] != null)
            {
                app_type = in_init_obj["apt"];
            }
            if (in_init_obj["acc"] != null)
            {
                account_id = in_init_obj["acc"];
            }
            if (in_init_obj["shw"] != null)
            {
                show_id = in_init_obj["shw"];
            }
            if (in_init_obj["skn"] != null)
            {
                skin_id = in_init_obj["skn"];
            }
            if (in_init_obj["prt"] != null)
            {
                partner_id = in_init_obj["prt"];
            }
            if (in_init_obj["api"] != null)
            {
                app_id = in_init_obj["api"];
            }
            if (in_init_obj["eml"] != null)
            {
                email_session = in_init_obj["eml"];
            }
            if (in_init_obj["dom"] != null)
            {
                page_domain = in_init_obj["dom"];
            }
            if (in_init_obj["scn"] != null)
            {
                scene_id = in_init_obj["scn"];
            }
            if (in_init_obj["emb"] != null)
            {
                embed_session = in_init_obj["emb"];
            }
            try
            {
                t_regex = /(?<=\/|\\\)(\w*)\.swf""(?<=\/|\\)(\w*)\.swf/gi;
                t_swf_url = in_loader.loaderURL;
                swf_name = t_regex.exec(t_swf_url)[0];
            }
            catch ($e:Error)
            {
            }
            events = new Object();
            try
            {
                t_so_date = new Date();
                t_so_date.setMonth((t_so_date.getMonth() + 1));
                so = new OddcastSharedObject(account_id, t_so_date);
            }
            catch (e:Error)
            {
            }
            if (so != null)
            {
                t_so_data = so.getDataObject();
                t_so_data = cleanUpOldData(t_so_data);
                so.write(t_so_data);
                so_data = getSOData();
            }
            var t_date:* = new Date();
            var t_m:* = t_date.getMonth();
            var t_d:* = t_date.getDate();
            session_event_map = new SessionEventMap();
            if (so != null)
            {
                if (so_data.date_mn == undefined || so_data.date_mn.getMonth() != t_date.getMonth())
                {
                    var _loc_5:int = 1;
                    so_data.visits = 1;
                    unique = _loc_5;
                    so_data.date_mn = new Date();
                    so_data.date_day = new Date();
                }
                else if (so_data.date_day == undefined || so_data.date_day.getDate() != t_date.getDate())
                {
                    var _loc_5:* = so_data;
                    _loc_5.visits = so_data.visits + 1;
                    unique = so_data.visits + 1;
                    so_data.date_day = new Date();
                }
                else
                {
                    unique = 0;
                }
                so.write(so.getDataObject());
            }
            else
            {
                unique = 0;
            }
            event("tss", "0");
            sendEvents();
            sendTimer = new Timer(send_frequency);
            sendTimer.addEventListener(TimerEvent.TIMER, sendEvents, false, 0, true);
            sendTimer.start();
            return;
        }// end function

        public function setAccountId(param1:String) : void
        {
            account_id = param1;
            return;
        }// end function

        public function setShowId(param1:String) : void
        {
            show_id = param1;
            return;
        }// end function

        public function setSceneId(param1:String) : void
        {
            scene_id = param1;
            return;
        }// end function

        public function setAppType(param1:String) : void
        {
            app_type = param1;
            return;
        }// end function

        public function setPageDomain(param1:String) : void
        {
            page_domain = param1;
            return;
        }// end function

        public function setSkinId(param1:String) : void
        {
            skin_id = param1;
            return;
        }// end function

        public function setPartnerId(param1:String) : void
        {
            partner_id = param1;
            return;
        }// end function

        public function setAppId(param1:String) : void
        {
            app_id = param1;
            return;
        }// end function

        public function setEmailSession(param1:String) : void
        {
            email_session = param1;
            return;
        }// end function

        public function setRequestDomain(param1:String) : void
        {
            req_domain = param1;
            return;
        }// end function

        public function event(param1:String, param2:String = null, param3:Number = 0, param4:String = null) : void
        {
            var _loc_5:Number = NaN;
            if (account_id != null && app_type != null && param1 != null)
            {
                _loc_5 = eventtime != null ? (Math.round(new Date().getTime() - eventtime.getTime())) : (0);
                if (_loc_5 > session_end)
                {
                    eventtime = new Date();
                    sendTimer.removeEventListener(TimerEvent.TIMER, sendEvents);
                    sendTimer.stop();
                    init(req_domain, init_obj);
                }
                if (param2 == null && scene_id == null)
                {
                    param2 = "0";
                }
                else if (param2 == null)
                {
                    param2 = scene_id;
                }
                if (events[param2] == null)
                {
                    events[param2] = new Array();
                }
                events[param2].push({event:param1, count:param3, value:param4});
                session_event_map.sessionEvent(param1);
            }
            return;
        }// end function

        protected function sendEvents(event:TimerEvent = null) : void
        {
            var _loc_3:String = null;
            var _loc_4:Number = NaN;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            var _loc_7:Number = NaN;
            var _loc_2:* = new String();
            for (_loc_3 in events)
            {
                
                _loc_4 = 0;
                while (_loc_4 < events[_loc_3].length)
                {
                    
                    _loc_2 = _loc_2 + ("&ev[" + _loc_3 + "][]=" + events[_loc_3][_loc_4].event);
                    if (events[_loc_3][_loc_4].count > 1)
                    {
                        _loc_2 = _loc_2 + ("&cnt[" + events[_loc_3][_loc_4].event + "]=" + events[_loc_3][_loc_4].count);
                    }
                    if (events[_loc_3][_loc_4].value != null)
                    {
                        _loc_2 = _loc_2 + ("&val[" + _loc_3 + "][" + events[_loc_3][_loc_4].event + "][]=" + String(events[_loc_3][_loc_4].value).substr(0, 20));
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            events = new Object();
            if (_loc_2.length > 6)
            {
                _loc_5 = "?";
                _loc_5 = _loc_5 + ("apt=" + app_type);
                _loc_5 = _loc_5 + ("&acc=" + account_id);
                if (swf_name != null)
                {
                    _loc_5 = _loc_5 + ("&swf=" + swf_name);
                }
                if (show_id != null)
                {
                    _loc_5 = _loc_5 + ("&shw=" + show_id);
                }
                if (skin_id != null)
                {
                    _loc_5 = _loc_5 + ("&skn=" + skin_id);
                }
                if (partner_id != null)
                {
                    _loc_5 = _loc_5 + ("&prt=" + partner_id);
                }
                if (app_id != null)
                {
                    _loc_5 = _loc_5 + ("&api=" + app_id);
                }
                if (email_session == "1")
                {
                    _loc_5 = _loc_5 + ("&eml=" + email_session);
                }
                if (embed_session != null)
                {
                    _loc_5 = _loc_5 + ("&emb=" + embed_session);
                }
                if (page_domain != null)
                {
                    _loc_5 = _loc_5 + ("&dom=" + page_domain);
                }
                _loc_5 = _loc_5 + ("&uni=" + unique);
                _loc_6 = session_event_map.getSessionEventData();
                _loc_5 = _loc_5 + ("&sm=" + _loc_6["session_mask"]);
                if (_loc_6["interval_mask"] != 0)
                {
                    _loc_5 = _loc_5 + ("&st[" + _loc_6["interval_mask"] + "]=" + _loc_6["session_time"]);
                }
                _loc_7 = eventtime == null ? (0) : (Math.round((new Date().getTime() - eventtime.getTime()) / 1000));
                _loc_5 = _loc_5 + ("&et=" + _loc_7 + _loc_2);
                sendRequest(_loc_5);
                eventtime = new Date();
            }
            return;
        }// end function

        protected function sendRequest(param1:String) : void
        {
            sendToURL(new URLRequest(req_domain + param1));
            return;
        }// end function

        public function destroy() : void
        {
            req_domain = null;
            app_type = null;
            account_id = null;
            show_id = null;
            skin_id = null;
            scene_id = null;
            partner_id = null;
            app_id = null;
            email_session = null;
            embed_session = null;
            page_domain = null;
            eventtime = null;
            events = null;
            init_obj = null;
            if (sendTimer != null)
            {
                sendTimer.stop();
                sendTimer.removeEventListener(TimerEvent.TIMER, sendEvents);
                sendTimer = null;
            }
            if (so != null)
            {
                so = null;
            }
            so_data = null;
            if (session_event_map != null)
            {
                session_event_map.destroy();
                session_event_map = null;
            }
            return;
        }// end function

        private function cleanUpOldData(param1:Object, param2:String = null, param3:String = null) : Object
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            for (_loc_4 in param1)
            {
                
                _loc_5 = param2 == null ? (_loc_4) : (param2);
                _loc_6 = param3 == null ? ("") : ("    " + param3);
                if (param1[_loc_4] is Object)
                {
                    cleanUpOldData(param1[_loc_4], _loc_5, _loc_6);
                }
            }
            if (param1.hasOwnProperty("eventtime") && param1.eventtime is Date)
            {
                for (_loc_4 in param1)
                {
                    
                    if (_loc_4 != "date_day" && _loc_4 != "date_mn" && _loc_4 != "visits")
                    {
                        delete param1[_loc_4];
                    }
                }
            }
            return param1;
        }// end function

        private function getSOData() : Object
        {
            var _loc_1:* = so.getDataObject();
            if (account_id != null)
            {
                if (_loc_1[account_id] == null)
                {
                    _loc_1[account_id] = new Object();
                }
                _loc_1 = _loc_1[account_id];
            }
            if (show_id != null)
            {
                if (_loc_1[show_id] == null)
                {
                    _loc_1[show_id] = new Object();
                }
                _loc_1 = _loc_1[show_id];
            }
            if (scene_id != null)
            {
                if (_loc_1[scene_id] == null)
                {
                    _loc_1[scene_id] = new Object();
                }
                _loc_1 = _loc_1[scene_id];
            }
            return _loc_1;
        }// end function

    }
}
