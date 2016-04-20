package com.oddcast.utils
{
    import flash.events.*;
    import flash.net.*;

    public class OddcastSharedObject extends Object
    {
        private var shared_obj:SharedObject;
        private var so_data:Object;
        private var max_so_size:Number = 10000;
        private var so_id:String;
        private var auto_delete_tries:int = 4;
        public static const PERMANENT:String = "permanent";
        private static var _enabled:Boolean = true;
        private static var flush_status:String = "";

        public function OddcastSharedObject(param1:String, param2:Date, param3:String = "") : void
        {
            var $id:* = param1;
            var $expiration:* = param2;
            var $priority:* = param3;
            if (!enabled)
            {
                return;
            }
            try
            {
                shared_obj = SharedObject.getLocal("oddcast_so", "/");
            }
            catch (e:Error)
            {
                throw e;
            }
            if (shared_obj != null && $id.length > 0)
            {
                if (shared_obj.size > max_so_size)
                {
                    internalDeleteSO();
                }
                shared_obj.addEventListener(NetStatusEvent.NET_STATUS, e_netStatus);
                cleanUp();
                so_id = $id;
                if (shared_obj.data[so_id] == null)
                {
                    shared_obj.data[so_id] = new Object();
                }
                if (shared_obj.data[so_id].data == null)
                {
                    shared_obj.data[so_id].data = new Object();
                }
                so_data = shared_obj.data[so_id].data;
                shared_obj.data[so_id].expiration = $expiration;
                shared_obj.data[so_id].priority = $priority;
                shared_obj.data[so_id].name = so_id;
                flushSO();
            }
            return;
        }// end function

        public function getDataObject() : Object
        {
            if (!enabled)
            {
                return null;
            }
            if (so_data == null)
            {
                return new Object();
            }
            return so_data;
        }// end function

        public function write(param1:Object) : Boolean
        {
            if (!enabled)
            {
                return false;
            }
            if (shared_obj != null && so_id.length > 0 && shared_obj.data[so_id] != null && shared_obj.data[so_id].data != null)
            {
                so_data = param1;
                shared_obj.data[so_id].data = so_data;
                flushSO();
                if (shared_obj.size > max_so_size)
                {
                    internalDeleteSO();
                }
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        public function deleteSO(param1:Boolean = false) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (!enabled)
            {
                return;
            }
            if (shared_obj != null)
            {
                if (param1)
                {
                    shared_obj.clear();
                }
                else
                {
                    _loc_2 = new Object();
                    for (_loc_3 in shared_obj.data)
                    {
                        
                        if (shared_obj.data[_loc_3].priority == PERMANENT)
                        {
                            _loc_2[_loc_3] = shared_obj.data[_loc_3];
                        }
                    }
                    shared_obj.clear();
                    for (_loc_4 in _loc_2)
                    {
                        
                        shared_obj.data[_loc_4] = _loc_2[_loc_4];
                    }
                    flushSO();
                }
            }
            return;
        }// end function

        public function traceSO(param1:Object = null, param2:String = "") : String
        {
            var _loc_4:Object = null;
            if (!enabled)
            {
                return null;
            }
            var _loc_3:String = "";
            if (param1 == null)
            {
                param1 = shared_obj.data;
            }
            for (_loc_4 in param1)
            {
                
                _loc_3 = _loc_3 + (param2 + " " + _loc_4 + "  " + param1[_loc_4].toString() + "\n");
                if (param1[_loc_4] is Object && param1[_loc_4] != null)
                {
                    _loc_3 = _loc_3 + traceSO(param1[_loc_4], param2 + "\t");
                }
            }
            return _loc_3;
        }// end function

        public function getSOSize() : Number
        {
            if (!enabled)
            {
                return Number.NaN;
            }
            return shared_obj.size;
        }// end function

        private function internalDeleteSO() : void
        {
            if (!enabled)
            {
                return;
            }
            if (auto_delete_tries == 0)
            {
                deleteSO(true);
            }
            else
            {
                deleteSO();
            }
            var _loc_2:* = auto_delete_tries - 1;
            auto_delete_tries = _loc_2;
            return;
        }// end function

        private function flushSO() : void
        {
            if (!enabled)
            {
                return;
            }
            if (flush_status != SharedObjectFlushStatus.PENDING)
            {
                try
                {
                    flush_status = shared_obj.flush();
                }
                catch ($e:Error)
                {
                }
            }
            return;
        }// end function

        private function cleanUp() : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:Date = null;
            var _loc_5:Date = null;
            if (!enabled)
            {
                return;
            }
            var _loc_1:* = new Object();
            for (_loc_2 in shared_obj.data)
            {
                
                if (_loc_2.length > 0 && shared_obj.data[_loc_2] != null)
                {
                    if (shared_obj.data[_loc_2].toString() == "[object Object]" && shared_obj.data[_loc_2].expiration != null && shared_obj.data[_loc_2].expiration is Date)
                    {
                        _loc_4 = shared_obj.data[_loc_2].expiration as Date;
                    }
                    _loc_5 = new Date();
                    if (_loc_4 == null || _loc_4.getTime() > _loc_5.getTime())
                    {
                        _loc_1[_loc_2] = shared_obj.data[_loc_2];
                    }
                }
            }
            shared_obj.clear();
            for (_loc_3 in _loc_1)
            {
                
                shared_obj.data[_loc_3] = _loc_1[_loc_3];
            }
            flushSO();
            return;
        }// end function

        private function e_netStatus(event:NetStatusEvent) : void
        {
            if (!enabled)
            {
                return;
            }
            if (event.info.level == "error")
            {
                shared_obj = null;
            }
            return;
        }// end function

        public static function set enabled(param1:Boolean) : void
        {
            _enabled = param1;
            return;
        }// end function

        public static function get enabled() : Boolean
        {
            return _enabled;
        }// end function

    }
}
