package 
{

    class Audio_List extends Object
    {
        public var KARA:Array;
        public var ANGELA:Array;
        public var VISITS:Array;
        public var TIME:Array;
        public var KARA_INTRO:Array;
        public var DAYS:Array;
        public var OBAMA:Array;
        public var PETE:Array;
        public var DANA:Array;
        private var SUNDAY:Array;
        private var MONDAY:Array;
        private var FRIDAY:Array;
        private var THURSDAY:Array;
        private var TUESDAY:Array;
        private var WEDNESDAY:Array;
        private var SATURDAY:Array;

        function Audio_List()
        {
            MONDAY = ["monday1"];
            TUESDAY = [];
            WEDNESDAY = [];
            THURSDAY = [];
            FRIDAY = ["friday1", "friday2"];
            SATURDAY = ["saturday1", "saturday2", "saturday3"];
            SUNDAY = SATURDAY;
            KARA = ["kara_1", "kara_2", "kara_3", "kara_4", "kara_5", "kara_6", "kara_7", "kara_8", "kara_9", "kara_10"];
            KARA_INTRO = ["homepage_1", "homepage_2", "homepage_3", "homepage_4", "homepage_5", "homepage_6", "homepage_7", "homepage_8", "homepage_9", "homepage_10", "homepage_11", "homepage_12", "homepage_13"];
            OBAMA = ["obama_1", "obama_2", "obama_3", "obama_4", "obama_5", "obama_6", "obama_7", "obama_8", "obama_9"];
            ANGELA = ["angela_1", "angela_2", "angela_3", "angela_4", "angela_5", "angela_6", "angela_7", "angela_8", "angela_9"];
            DANA = ["dana_1", "dana_2", "dana_3", "dana_4", "dana_5", "dana_6", "dana_7", "dana_8", "dana_9"];
            PETE = ["pete_1", "pete_2", "pete_3", "pete_4", "pete_5", "pete_6", "pete_7", "pete_8", "pete_9"];
            TIME = ["aftermidnight", "morning", "noon", "evening", "midnight"];
            VISITS = ["visit1", "visit2", "visit3"];
            DAYS = [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY];
            return;
        }// end function

    }
}
