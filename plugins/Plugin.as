class plugins.Plugin extends IEDObject
{
    var init, _player, _manager, name, __get__player, __get__manager, __set__manager, __set__player;
    function Plugin(Void)
    {
        super();
        this.init();
        _player = null;
        _manager = null;
        name = "";
    } // End of the function
    function set player(p)
    {
        _player = p;
        //return (this.player());
        null;
    } // End of the function
    function get player()
    {
        return (_player);
    } // End of the function
    function set manager(m)
    {
        _manager = m;
        //return (this.manager());
        null;
    } // End of the function
    function get manager()
    {
        return (_manager);
    } // End of the function
    function setUp(evt)
    {
    } // End of the function
    function argsReady(evt)
    {
        _manager.setPluginReady(name);
    } // End of the function
} // End of Class
