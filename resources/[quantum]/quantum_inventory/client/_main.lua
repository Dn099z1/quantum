quantum = Proxy.getInterface('quantum')

cInventory = {}
Tunnel.bindInterface('quantum_inventory', cInventory)
sInventory = Tunnel.getInterface('quantum_inventory')

disableActions = false
currentChestType = nil
currentLootId = nil

RegisterNetEvent('inventory:equipWeapon')
AddEventHandler('inventory:equipWeapon', function(weaponName)
    local playerPed = PlayerPedId()
    Citizen.Wait(100)
    SetCurrentPedWeapon(playerPed, GetHashKey(weaponName), true)
end)

RegisterNetEvent('eq')
RegisterNetEvent('eq', function()
    local playerPed = PlayerPedId()  
    RemoveAllPedWeapons(playerPed, true)
end)




RegisterKeyMapping("openInventory", "Abrir inventario", 'KEYBOARD', "Oem_3")
RegisterCommand("openInventory", function()
    local playerPed = PlayerPedId()
    if (not disableActions and GetEntityHealth(playerPed) > 100 and not LocalPlayer.state.BlockTasks and not LocalPlayer.state.Handcuff) then
        disableActions = true
        cInventory.openInventory('open', 'ground')
    end
end)

RegisterNetEvent('updateInventory', function()
    cInventory.openInventory('update', currentChestType, currentLootId)
end)

RegisterNuiCallback('closeInventory', function(data)
    disableActions = false
    cInventory.closeInventory(data)
end)

RegisterNetEvent('quantum_inventory:enableActions', function()
    disableActions = false
end)

RegisterNetEvent('quantum_inventory:disableActions', function()
    disableActions = true
end)


CreateThread(function()
    local sleep = 1000
    while true do
        sleep = 0
        DisplayAreaName(false)
        DisplayCash(false) 
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(3) 
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(7) 
        HideHudComponentThisFrame(9) 
        Citizen.Wait(sleep)
    end
end)


