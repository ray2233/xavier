package vhss.playback
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;

    public class GazeController extends Object
    {
        private var user_gaze_timer:Timer;
        private var host_holder:HostHolder;
        private var follow_in_page:Boolean = false;
        private var mouse_mode:int;
        private var stage_ref:Stage;

        public function GazeController(param1:HostHolder)
        {
            host_holder = param1;
            user_gaze_timer = new Timer(1, 1);
            user_gaze_timer.addEventListener(TimerEvent.TIMER_COMPLETE, e_userGazeDone);
            return;
        }// end function

        public function setGazeUser(param1:Number, param2:Number, param3:Number = 100) : void
        {
            if (user_gaze_timer != null)
            {
                user_gaze_timer.stop();
            }
            user_gaze_timer.delay = param2 * 1000;
            user_gaze_timer.start();
            stopPageRequest();
            host_holder.setGaze(param1, param2, param3);
            return;
        }// end function

        public function setStageReference(param1:Stage) : void
        {
            stage_ref = param1;
            return;
        }// end function

        public function setGazePage(param1:Number, param2:Number, param3:Number = 100) : void
        {
            if (follow_in_page)
            {
                host_holder.setGaze(param1, param2, param3);
            }
            return;
        }// end function

        public function followInPage(param1:Boolean) : void
        {
            follow_in_page = param1;
            if (stage_ref != null)
            {
                if (follow_in_page)
                {
                    stage_ref.addEventListener(Event.MOUSE_LEAVE, e_mouseLeave);
                    stage_ref.addEventListener(MouseEvent.MOUSE_OVER, e_mouseOver);
                }
                else
                {
                    stage_ref.removeEventListener(Event.MOUSE_LEAVE, e_mouseLeave);
                    stage_ref.removeEventListener(MouseEvent.MOUSE_OVER, e_mouseOver);
                }
            }
            if (follow_in_page)
            {
                startPageRequest();
            }
            else
            {
                stopPageRequest();
            }
            return;
        }// end function

        public function stopPageRequest() : void
        {
            try
            {
                ExternalInterface.call("VHSS_Command", "vh_followOnPage", 0);
            }
            catch ($e:Error)
            {
            }
            return;
        }// end function

        public function startPageRequest() : void
        {
            try
            {
                ExternalInterface.call("VHSS_Command", "vh_followOnPage", 4);
            }
            catch ($e:Error)
            {
            }
            return;
        }// end function

        private function e_mouseLeave(event:Event) : void
        {
            startPageRequest();
            stage_ref.addEventListener(MouseEvent.MOUSE_OVER, e_mouseOver);
            return;
        }// end function

        private function e_mouseOver(event:MouseEvent) : void
        {
            stopPageRequest();
            stage_ref.removeEventListener(MouseEvent.MOUSE_OVER, e_mouseOver);
            return;
        }// end function

        private function e_userGazeDone(event:Event) : void
        {
            user_gaze_timer.stop();
            if (follow_in_page)
            {
                startPageRequest();
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (user_gaze_timer != null)
            {
                user_gaze_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, e_userGazeDone);
                user_gaze_timer = null;
            }
            if (stage_ref != null)
            {
                stage_ref.removeEventListener(Event.MOUSE_LEAVE, e_mouseLeave);
                stage_ref.removeEventListener(MouseEvent.MOUSE_OVER, e_mouseOver);
                stage_ref = null;
            }
            return;
        }// end function

    }
}
