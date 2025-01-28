cInventory.getWeaponsBag = function()
    local weapons = quantum.getWeapons()
    local formattedWeapons = {}

    for k,v in pairs(weapons) do
        local currentItem = config.items[string.lower(k)]
        if currentItem then 
            table.insert(formattedWeapons, {
                index = k,
                name = currentItem.name,
                ammo = v.ammo
            })
        end
    end

    return formattedWeapons
end

cInventory.unequipAllWeapons = function()
    local weapons = quantum.getWeapons()

    for k,v in pairs(weapons) do
        cInventory.unequipWeapon(k)
    end
end

cInventory.removeWeapons = function()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
end


cInventory.addAmmo = function(index, amount)
    AddAmmoToPed(PlayerPedId(), index, tonumber(amount))
end
RegisterNetEvent('inventory:unequipWeapon')
AddEventHandler('inventory:unequipWeapon', function(weaponName)
    print('a')
    
    cInventory.unequipWeapon(weaponName)
end)

cInventory.unequipWeapon = function(index)
    -- Obtém o ID do ped (personagem) do jogador
    local playerPed = PlayerPedId()
    
    -- Converte o nome da arma para um hash (identificador único)
    local weaponHash = GetHashKey(string.upper(index))
    
    -- Obtém a quantidade de munição atual para essa arma
    local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)

    -- Remove a arma do jogador
    RemoveWeaponFromPed(playerPed, weaponHash)

    -- Reativa o item no inventário (gera 1 item de inventário com nome 'index')
    -- sInventory.giveInventoryItem(0, string.lower(index), 1)

    -- Se houver munição, também a remove do jogador e adiciona de volta ao inventário
    if ammoCount > 0 then
        SetPedAmmo(playerPed, weaponHash, 0)  -- Remove toda a munição

        -- Mapeia os tipos de armas para seus respectivos tipos de munição
        local ammoTypeMap = {
            ['weapon_combatpistol'] = 'm_weapon_pistol',
            ['weapon_pistolxm3'] = 'm_weapon_pistol',
            ['weapon_heavypistol'] = 'm_weapon_pistol',
            ['weapon_smg_mk2'] = 'm_weapon_smg',
            ['weapon_combatpdw'] = 'm_weapon_smg',
            ['weapon_smg'] = 'm_weapon_smg',
            ['weapon_carbinerifle_mk2'] = 'm_weapon_rifle',
            ['weapon_carbinerifle'] = 'm_weapon_rifle',
            ['weapon_gusenberg'] = 'm_weapon_shotgun',
            ['weapon_revolver_mk2'] = 'm_weapon_pistol',
            ['weapon_tacticalrifle'] = 'm_weapon_rifle',
            ['weapon_heavyrifle'] = 'm_weapon_rifle',
            ['weapon_sniperrifle'] = 'm_weapon_sniper',
            ['weapon_combatshotgun'] = 'm_weapon_shotgun',
            ['weapon_pumpshotgun_mk2'] = 'm_weapon_shotgun',
            ['weapon_pumpshotgun'] = 'm_weapon_shotgun',
            ['weapon_specialcarbine_mk2'] = 'm_weapon_rifle',
            ['weapon_specialcarbine'] = 'm_weapon_rifle',
            ['weapon_compactrifle'] = 'm_weapon_rifle',
            ['weapon_dbshotgun'] = 'm_weapon_shotgun',
            ['weapon_sawnoffshotgun'] = 'm_weapon_shotgun',
            ['weapon_tecpistol'] = 'm_weapon_smg',
            ['weapon_microsmg'] = 'm_weapon_smg',
            ['weapon_pistol_mk2'] = 'm_weapon_pistol',
            ['weapon_vintagepistol'] = 'm_weapon_pistol',
            ['weapon_gadgetpistol'] = 'm_weapon_pistol',
            ['weapon_doubleaction'] = 'm_weapon_pistol',
            ['weapon_snspistol_mk2'] = 'm_weapon_pistol',
            ['weapon_assaultrifle_mk2'] = 'm_weapon_rifle',
        }

        -- Verifica se existe o tipo de munição mapeado para essa arma
        local ammoType = ammoTypeMap[string.lower(index)]

        -- Se o tipo de munição for encontrado, adiciona de volta ao inventário
        if ammoType then
            sInventory.giveInventoryItem(0, ammoType, ammoCount)
        else
            print("Ammo type for this weapon not found!")  -- Caso o tipo de munição não seja encontrado
        end
    end

    -- Fecha o inventário
    cInventory.closeInventory()

    -- Notifica o jogador que a arma foi desarmada
    config.functions.clientNotify(config.texts.notify_title, config.texts.notify_unequip_weapon(config.items[string.lower(index)].name), 5000)
end




RegisterNuiCallback('unequipWeapon', function(data)
    cInventory.unequipWeapon(data.index)
end)