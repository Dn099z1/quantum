Tunnel = module('quantum','lib/Tunnel')
Proxy = module('quantum','lib/Proxy')
Tools = module('quantum','lib/Tools')

quantum = Proxy.getInterface('quantum')

if (IsDuplicityVersion()) then
    quantumClient = Tunnel.getInterface('quantum')
end