local Tunnel = module('quantum',"lib/Tunnel")
local Proxy = module('quantum',"lib/Proxy")
quantum = Proxy.getInterface("quantum")

srv = {}
Tunnel.bindInterface(GetCurrentResourceName(), srv)
cli = Tunnel.getInterface(GetCurrentResourceName())

srv.checkPermission = function(permission)
    local _source = source
    local _userId = quantum.getUserId(_source)
    if (_userId) and quantum.hasPermission(_userId, permission) then
        return true
    end
    return false
end