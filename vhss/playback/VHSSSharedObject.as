package vhss.playback
{
    import com.oddcast.utils.*;
    import flash.events.*;

    public class VHSSSharedObject extends Object
    {
        private var account_id:String;
        private var show_id:String;
        private var embed_id:String;
        private var so:OddcastSharedObject;
        private var so_data:Object;
        private var session_timer:SessionPlaybackTimer;
        private const thirty_days:Number = 2.592e+009;
        private const one_day:Number = 86400000;
        private const session_time:Number = 420000;

        public function VHSSSharedObject(param1:String, param2:String, param3:String)
        {
            var t_date:Date;
            var $account_id:* = param1;
            var $show_id:* = param2;
            var $embed_id:* = param3;
            account_id = $account_id;
            show_id = $show_id;
            embed_id = $embed_id;
            try
            {
                t_date = new Date();
                t_date.setMonth((t_date.getMonth() + 1));
                so = new OddcastSharedObject("vhss_player", t_date);
            }
            catch ($e:Error)
            {
            }
            if (so != null)
            {
                so_data = so.getDataObject();
                initSharedObject();
            }
            return;
        }// end function

        public function destroy() : void
        {
            so = null;
            so_data = null;
            if (session_timer)
            {
                session_timer.stop();
                session_timer.removeEventListener(TimerEvent.TIMER, e_resetDate);
                session_timer = null;
            }
            return;
        }// end function

        public function isPlayable(param1:String, param2:Number, param3:Number) : Boolean
        {
            var _loc_4:Date = null;
            var _loc_5:Date = null;
            var _loc_6:Boolean = false;
            var _loc_7:Number = NaN;
            if (so == null)
            {
                return true;
            }
            if (so_data[account_id][show_id][embed_id][param1] == null)
            {
                so_data[account_id][show_id][embed_id][param1] = new Object();
            }
            _loc_4 = so_data[account_id][show_id][embed_id][param1].date == null ? (new Date(-1)) : (so_data[account_id][show_id][embed_id][param1].date as Date);
            _loc_5 = new Date();
            _loc_6 = param3 == 0 && param2 > 0;
            if (_loc_6)
            {
                if (session_timer == null)
                {
                    session_timer = new SessionPlaybackTimer(10000);
                    session_timer.audio_id = param1;
                    session_timer.addEventListener(TimerEvent.TIMER, e_resetDate);
                    session_timer.start();
                }
                _loc_7 = session_time;
            }
            else
            {
                if (session_timer != null && so != null)
                {
                    session_timer.stop();
                    session_timer.removeEventListener(TimerEvent.TIMER, e_resetDate);
                    session_timer = null;
                }
                _loc_7 = one_day * param3;
            }
            if (param2 == 0)
            {
                return false;
            }
            if (param2 < 0)
            {
                if (so_data[account_id][show_id][embed_id][param1] != null)
                {
                    delete so_data[account_id][show_id][embed_id][param1];
                }
                if (so != null)
                {
                    so.write(so_data);
                }
                return true;
            }
            else
            {
                if (so_data[account_id][show_id][embed_id][param1] == null || _loc_4.getTime() + _loc_7 < _loc_5.getTime())
                {
                    so_data[account_id][show_id][embed_id][param1] = new Object();
                    so_data[account_id][show_id][embed_id][param1].date = new Date();
                    so_data[account_id][show_id][embed_id][param1].plays = 1;
                    if (so != null)
                    {
                        so.write(so_data);
                    }
                    return true;
                }
                else
                {
                    if (_loc_4.getTime() + _loc_7 > _loc_5.getTime() && so_data[account_id][show_id][embed_id][param1].plays < param2)
                    {
                        var _loc_8:* = so_data[account_id][show_id][embed_id][param1];
                        var _loc_9:* = so_data[account_id][show_id][embed_id][param1].plays + 1;
                        _loc_8.plays = _loc_9;
                        if (so != null)
                        {
                            so.write(so_data);
                        }
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }// end function

        private function initSharedObject() : void
        {
            try
            {
                cleanUp();
            }
            catch ($e:Error)
            {
            }
            if (so_data[account_id] == null)
            {
                so_data[account_id] = new Object();
            }
            if (so_data[account_id][show_id] == null)
            {
                so_data[account_id][show_id] = new Object();
            }
            if (so_data[account_id][show_id][embed_id] == null)
            {
                so_data[account_id][show_id][embed_id] = new Object();
            }
            so.write(so_data);
            return;
        }// end function

        private function cleanUp() : void
        {
            var _loc_3:String = null;
            var _loc_1:* = new Date();
            var _loc_2:* = so_data[account_id][show_id][embed_id];
            for (_loc_3 in _loc_2)
            {
                
                if (_loc_2[_loc_3].date != null && _loc_2[_loc_3].date.getTime() < _loc_1.getTime() - thirty_days)
                {
                    delete _loc_2[_loc_3];
                }
            }
            return;
        }// end function

        private function e_resetDate(event:TimerEvent) : void
        {
            if (so != null)
            {
                so_data[account_id][show_id][embed_id][session_timer.audio_id].date = new Date();
                so.write(so_data);
            }
            return;
        }// end function

    }
}
