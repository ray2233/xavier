class PluginManager extends IEDObject
{
    var init, _player, addEventListener, _plugins, dispatchEvent;
    function PluginManager(player)
    {
        super();
        this.init();
        _player = player;
        this.addEventListener("pluginsReady", _player);
        _plugins = {};
    } // End of the function
    function addPlugin(plugin, pName)
    {
        var _loc2 = plugin;
        _plugins[pName] = {plugin: _loc2, ready: false};
        _loc2.player = _player;
        _loc2.manager = this;
        _loc2.name = pName;
        _player.addEventListener("setUp", _loc2);
        _player.addEventListener("argsReady", _loc2);
        _player.addEventListener("videoSize", _loc2);
        _player.addEventListener("nsDone", _loc2);
        _player.addEventListener("fullscreen", _loc2);
        _player.addEventListener("reconnect", _loc2);
        _player.addEventListener("tryFallBack", _loc2);
        _player.addEventListener("nsNotFound", _loc2);
        _player.addEventListener("nsStreamReady", _loc2);
        _player.addEventListener("nsBuffering", _loc2);
        _player.addEventListener("nsTimeUpdate", _loc2);
        return (_plugins[pName]);
    } // End of the function
    function removePlugin(pName)
    {
        var _loc2 = _plugins[pName].plugin;
        _player.removeEventListener("setUp", _loc2);
        _player.removeEventListener("argsReady", _loc2);
        _player.removeEventListener("videoSize", _loc2);
        _player.removeEventListener("nsDone", _loc2);
        _player.removeEventListener("fullscreen", _loc2);
        _player.removeEventListener("reconnect", _loc2);
        _player.removeEventListener("tryFallBack", _loc2);
        _player.removeEventListener("nsNotFound", _loc2);
        _player.removeEventListener("nsStreamReady", _loc2);
        _player.removeEventListener("nsBuffering", _loc2);
        _player.removeEventListener("nsTimeUpdate", _loc2);
        delete _plugins[pName];
    } // End of the function
    function getPlugin(pName)
    {
        return (_plugins[pName].plugin);
    } // End of the function
    function setPluginReady(pName)
    {
        _plugins[pName].ready = true;
        for (var _loc2 in _plugins)
        {
            if (_plugins[_loc2].ready != true)
            {
                return;
            } // end if
        } // end of for...in
        this.dispatchEvent({type: "pluginsReady"});
    } // End of the function
} // End of Class
