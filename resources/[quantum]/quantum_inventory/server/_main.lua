quantum = Proxy.getInterface('quantum')
quantumClient = Tunnel.getInterface('quantum')

cInventory = Tunnel.getInterface('quantum_inventory')

sInventory = {}
Tunnel.bindInterface('quantum_inventory', sInventory)

RegisterCommand("dnzx", function()
    local plate = 10
    TriggerClientEvent('quantum_garage:lockpickUsage',-1, plate)
end, false) 