Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')
quantum = Proxy.getInterface('quantum')

config = {}

isServer = IsDuplicityVersion()
if (isServer) then
    srv = {}
    Tunnel.bindInterface(GetCurrentResourceName(), srv)
    vRPclient = Tunnel.getInterface('quantum')
else
    vSERVER = Tunnel.getInterface(GetCurrentResourceName())
    vRPserver = Tunnel.getInterface('quantum')
end