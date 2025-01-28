srv = {}
Tunnel.bindInterface(GetCurrentResourceName(), srv)

local joined = {}

srv.getLastPosition = function()
    local source = source
    local coords = vector3(-1648.84, -994.1143, 13.00293)
    if (source) then
        local datatable = quantum.getUserDataTable(quantum.getUserId(source))
        if (datatable) and datatable.position then
            local position = datatable.position
            coords = vector3(position.x, position.y, position.z)
        end
    end
    return coords
end


RegisterServerEvent("CanX-SpawnSelector:OpenSpawner")
AddEventHandler("CanX-SpawnSelector:OpenSpawner", function()
    if not joined[GetPlayerIdentifiers(source)[1]] then
        TriggerClientEvent("CanX-SpawnSelector:Open", source)
        joined[GetPlayerIdentifiers(source)[1]] = true
    end
end)
