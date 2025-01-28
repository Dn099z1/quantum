Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')
Tools = module('quantum', 'lib/Tools')

quantum = {}
Proxy.addInterface('quantum', quantum)
Tunnel.bindInterface('quantum', quantum)
exportTable(quantum)

vRP = {}
Proxy.addInterface('vRP', vRP)
Tunnel.bindInterface('vRP', vRP)
exportTable(vRP)

config = {}

if (IsDuplicityVersion()) then
    quantumClient = Tunnel.getInterface('quantum')
else
    quantumServer = Tunnel.getInterface('quantum')
end