package vhss.api
{
    import flash.events.*;
    import flash.net.*;
    import vhss.*;
    import vhss.events.*;
    import vhss.structures.*;

    public class LeadSender extends EventDispatcher
    {
        private var lead_ldr:DataLoader;
        private var lead_xml:XML;

        public function LeadSender()
        {
            return;
        }// end function

        public function sendLead(param1:Object, param2:SlideShowStruct, param3:SceneStruct) : void
        {
            lead_xml = <SKINLEAD SHOWID="""" SLIDEID="""" SKINID="""" ACC="""" DOOR="""" ACCTYPE="""" TITLE=""""/>")("<SKINLEAD SHOWID="" SLIDEID="" SKINID="" ACC="" DOOR="" ACCTYPE="" TITLE=""/>;
            lead_xml.@SHOWID = param2.show_id;
            lead_xml.@SLIDEID = param3.id;
            lead_xml.@SKINID = param3.skin.id;
            lead_xml.@ACC = param2.account_id;
            lead_xml.@DOOR = param2.door_id;
            lead_xml.@ACCTYPE = param2.edition_id;
            lead_xml.@TITLE = param3.title;
            var _loc_4:* = param1.xml;
            var _loc_5:Number = 0;
            while (_loc_5 < _loc_4.child("F").length())
            {
                
                if (param1["tf" + (_loc_5 + 1)] != null)
                {
                    _loc_4.child("F")[_loc_5] = param1["tf" + (_loc_5 + 1)];
                }
                _loc_5 = _loc_5 + 1;
            }
            lead_xml.appendChild(_loc_4);
            lead_ldr = new DataLoader();
            var _loc_6:* = new URLRequest(Constants.VHSS_DOMAIN + Constants.SEND_LEAD_PHP);
            new URLRequest(Constants.VHSS_DOMAIN + Constants.SEND_LEAD_PHP).method = URLRequestMethod.POST;
            _loc_6.data = lead_xml.toXMLString();
            _loc_6.contentType = "text/xml";
            lead_ldr.addEventListener(DataLoaderEvent.ON_DATA_READY, e_dataReady);
            lead_ldr.load(_loc_6, "lead");
            return;
        }// end function

        private function e_dataReady(event:DataLoaderEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

    }
}
