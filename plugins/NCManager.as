class plugins.NCManager extends plugins.Plugin
{
    var init, addEventListener, parent;
    function NCManager(Void)
    {
        super();
        this.init();
    } // End of the function
    function setUp(evt)
    {
        var _loc2 = evt.target;
        this.addEventListener("ncConnected", _loc2);
    } // End of the function
    function argsReady(evt)
    {
        if (evt.args.streamName == null)
        {
            return;
        } // end if
        this.connect(evt);
    } // End of the function
    function connect(evt)
    {
        var _loc2 = new NetConnection();
        _loc2.parent = this;
        _loc2.onStatus = function (info)
        {
            if (info.code == "NetConnection.Connect.Success")
            {
                parent.dispatchEvent({type: "ncConnected", nc: this});
                parent._manager.setPluginReady(parent.name);
            } // end if
        };
        _loc2.connect(null);
    } // End of the function
} // End of Class
