cInventory.TextFloating = function(text, coord)
    AddTextEntry('FloatingHelpText', text)
    SetFloatingHelpTextWorldPosition(0, coord)
    SetFloatingHelpTextStyle(0, true, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpText')
    EndTextCommandDisplayHelp(1, false, false, -1)
end

cInventory.animation = function(dict, anim, loop)
    quantum.playAnim(true,{{dict,anim}},loop)
end

RegisterNUICallback('getPlayerInfo', function(data, cb)

    local playerInfo = {
        name = "Jogador Teste", -- Nome fictício
        level = 42,             -- Nível fictício
        avatar = "https://media.discordapp.net/attachments/725482717877370902/1322232046654984192/image.png?ex=6771718d&is=6770200d&hm=b19333181d63ae4014bd3900aa8cccdcf2d831dc00a9614ec3369899db2627c4&=&format=webp&quality=lossless" -- URL do avatar fictício
    }
    return playerInfo
end)


cInventory.getVehicleDamage = function()
    local pVehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 71)
    if (DoesEntityExist(pVehicle)) then
        return GetVehicleEngineHealth(pVehicle)
    end
    return 0.0
end
RegisterNetEvent('applyVest')
AddEventHandler('applyVest', function()
    local ped = PlayerPedId()

    SetPedComponentVariation(ped, 9, 1, 1, 0) 

end)
RegisterNetEvent('removeVest')
AddEventHandler('removeVest', function()
    local ped = PlayerPedId()

    SetPedComponentVariation(ped, 9, 0, 0, 0) 

end)

RegisterNetEvent('quantum_inventory:LockpickAnim', function(vehicle)
	SetVehicleNeedsToBeHotwired(vehicle, true)
	IsVehicleNeedsToBeHotwired(vehicle)
end)