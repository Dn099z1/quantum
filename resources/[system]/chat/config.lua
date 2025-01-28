Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')

if IsDuplicityVersion() then
    quantum = Proxy.getInterface('quantum')
    quantumClient = Tunnel.getInterface('quantum')
else
    quantum = Proxy.getInterface('quantum')
end