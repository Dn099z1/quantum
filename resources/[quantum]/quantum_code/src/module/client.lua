vSERVER = Tunnel.getInterface(GetCurrentResourceName())

RegisterKeyMapping('openCodes', '[quantum Police] - Códigos Q', 'keyboard', 'J')
RegisterCommand('openCodes', function()
    if (vSERVER.checkPermission({ 'policia.permissao', 'deic.permissao' })) then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'OPEN_TENCODE' })
    end
end)

RegisterNUICallback('code', function(data, cb)
    vSERVER.executeCode(data.code)
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)
function GetWeaponNameFromHash(weaponHash)
    local weapons = {
        [-1075685676] = "weapon_pistol_mk2",
        [1593441988] = "weapon_combatpistol",
        [324215364] = "weapon_assaultrifle",
        [970310034] = "weapon_carbine_rifle",
    }

    return weapons[weaponHash] or "unknown_weapon"
end

RegisterCommand('pedwep', function(source, args)
    
    local player = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(player)
   print(GetWeaponNameFromHash(currentWeapon))
end)