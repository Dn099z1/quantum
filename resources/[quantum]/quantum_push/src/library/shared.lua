Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')
quantum = Proxy.getInterface('quantum')

if (IsDuplicityVersion()) then
    quantum = Proxy.getInterface('quantum')
else
    quantum = Proxy.getInterface('quantum')
end