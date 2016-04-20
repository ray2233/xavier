package com.oddcast.reports
{

    public class SessionEventMap extends Object
    {
        private var session_events_ar:Array;
        private var interval_mask:Number = 0;
        private var session_mask:Number = 0;
        private var start_time:Date;

        public function SessionEventMap()
        {
            session_events_ar = new Array({event:"acmic", bit:0}, {event:"actts", bit:1}, {event:"acph", bit:2}, {event:"acup", bit:3}, {event:"edems", bit:4}, {event:"edsv", bit:5}, {event:"uirt", bit:6}, {event:"edvscr", bit:7}, {event:"edapu", bit:8}, {event:"edbgu", bit:9}, {event:"ce1", bit:10}, {event:"ce2", bit:11}, {event:"ce3", bit:12}, {event:"ce4", bit:13}, {event:"ce5", bit:14}, {event:"ce6", bit:15}, {event:"ce7", bit:16}, {event:"ce8", bit:17}, {event:"uieb", bit:18}, {event:"uiebms", bit:19}, {event:"uiebfb", bit:20}, {event:"edphs", bit:21}, {event:"accc", bit:22}, {event:"edvdx", bit:23}, {event:"edaux", bit:24}, {event:"edfbc", bit:25}, {event:"uiebws", bit:26}, {event:"edecs", bit:27}, {event:"uiebyt", bit:28}, {event:"eddlph", bit:29}, {event:"edsrhd", bit:30}, {event:"edsrse", bit:31}, {event:"edsrsm", bit:32}, {event:"edsrpb", bit:33}, {event:"edsrpp", bit:34}, {event:"edsrpl", bit:35}, {event:"edsrwc", bit:36}, {event:"edmbls", bit:37}, {event:"ce9", bit:38}, {event:"ce10", bit:39}, {event:"ce11", bit:40}, {event:"ce12", bit:41}, {event:"ce13", bit:42}, {event:"ce14", bit:43}, {event:"ce15", bit:44}, {event:"ce16", bit:45});
            start_time = new Date();
            return;
        }// end function

        public function getSessionEventData() : Object
        {
            var _loc_1:* = new Object();
            _loc_1["session_mask"] = session_mask;
            _loc_1["interval_mask"] = interval_mask;
            _loc_1["session_time"] = Math.round((new Date().getTime() - start_time.getTime()) / 1000);
            session_mask = session_mask + interval_mask;
            interval_mask = 0;
            return _loc_1;
        }// end function

        public function sessionEvent(param1:String) : void
        {
            var _loc_3:Object = null;
            var _loc_2:Number = 0;
            while (_loc_2 < session_events_ar.length)
            {
                
                if (session_events_ar[_loc_2].event == param1)
                {
                    _loc_3 = session_events_ar[_loc_2];
                    session_events_ar.splice(_loc_2, 1);
                    interval_mask = interval_mask + Math.pow(2, _loc_3.bit);
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function destroy() : void
        {
            session_events_ar = null;
            start_time = null;
            return;
        }// end function

    }
}
