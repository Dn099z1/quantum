config.functions = {
    weaponTitle = 'Upper', -- Upper = Maicusulo / Lower = Minusculo isso é como o inventario interpreta as armas, NÃO MEXA SE NÃO SABE OQUE ESTÁ FAZENDO!
    weaponAmmoMap = {
        ['WEAPON_COMBATPISTOL'] = 'm_weapon_pistol',
        ['WEAPON_PISTOLXM3'] = 'm_weapon_pistol',
        ['WEAPON_HEAVYPISTOL'] = 'm_weapon_pistol',
        ['WEAPON_COMBATPDW'] = 'm_weapon_smg',
        ['WEAPON_SMG'] = 'm_weapon_smg',
        ['WEAPON_CARBINERIFLE_MK2'] = 'm_weapon_rifle',
        ['WEAPON_CARBINERIFLE'] = 'm_weapon_rifle',
        ['WEAPON_REVOLVER_MK2'] = 'm_weapon_pistol',
        ['WEAPON_SMG_MK2'] = 'm_weapon_smg',
        ['WEAPON_TACTICALRIFLE'] = 'm_weapon_rifle',
        ['WEAPON_HEAVYRIFLE'] = 'm_weapon_rifle',
        ['WEAPON_SNIPERRIFLE'] = 'm_weapon_sniper',
        ['WEAPON_COMBATSHOTGUN'] = 'm_weapon_shotgun',
        ['WEAPON_PUMPSHOTGUN_MK2'] = 'm_weapon_shotgun',
        ['WEAPON_PUMPSHOTGUN'] = 'm_weapon_shotgun',
        ['WEAPON_MILITARYRIFLE'] = 'm_weapon_rifle',
        ['WEAPON_SPECIALCARBINE_MK2'] = 'm_weapon_rifle',
        ['WEAPON_SPECIALCARBINE'] = 'm_weapon_rifle',
        ['WEAPON_COMPACTRIFLE'] = 'm_weapon_rifle',
        ['WEAPON_DBSHOTGUN'] = 'm_weapon_shotgun',
        ['WEAPON_SAWNOFFSHOTGUN'] = 'm_weapon_shotgun',
        ['WEAPON_TECPISTOL'] = 'm_weapon_smg',
        ['WEAPON_MICROSMG'] = 'm_weapon_smg',
        ['WEAPON_PISTOL_MK2'] = 'm_weapon_pistol',
        ['WEAPON_VINTAGEPISTOL'] = 'm_weapon_pistol',
        ['WEAPON_GADGETPISTOL'] = 'm_weapon_pistol',
        ['WEAPON_DOUBLEACTION'] = 'm_weapon_pistol',
        ['WEAPON_SNSSPISTOL_MK2'] = 'm_weapon_pistol',
        ['WEAPON_ASSAULTRIFLE_MK2'] = 'm_weapon_rifle',
    },
    
    weaponMap = {
        'WEAPON_COMBATPISTOL',
        'WEAPON_PISTOLXM3',
        'WEAPON_HEAVYPISTOL',
        'WEAPON_COMBATPDW',
        'WEAPON_SMG',
        'WEAPON_CARBINERIFLE_MK2',
        'WEAPON_CARBINERIFLE',
        'WEAPON_REVOLVER_MK2',
        'WEAPON_SMG_MK2',
        'WEAPON_TACTICALRIFLE',
        'WEAPON_HEAVYRIFLE',
        'WEAPON_SNIPERRIFLE',
        'WEAPON_COMBATSHOTGUN',
        'WEAPON_PUMPSHOTGUN_MK2',
        'WEAPON_PUMPSHOTGUN',
        'WEAPON_MILITARYRIFLE',
        'WEAPON_SPECIALCARBINE_MK2',
        'WEAPON_SPECIALCARBINE',
        'WEAPON_COMPACTRIFLE',
        'WEAPON_DBSHOTGUN',
        'WEAPON_SAWNOFFSHOTGUN',
        'WEAPON_TECPISTOL',
        'WEAPON_MICROSMG',
        'weapon_pistol_mk2',
        'WEAPON_PISTOL_MK2',
        'WEAPON_VINTAGEPISTOL',
        'WEAPON_GADGETPISTOL',
        'WEAPON_DOUBLEACTION',
        'WEAPON_SNSSPISTOL_MK2',
        'WEAPON_ASSAULTRIFLE_MK2'
    },
    
    
    clientNotify = function(title, msg, time)
        TriggerEvent(
            'notify',
            title,
            msg,
            time
        )
    end,

    serverNotify = function(source, title, msg, time)
        local _source = source 
        TriggerClientEvent(
            'notify',
            _source,
            title,
            msg,
            time
        )
    end,

    getVehOwnerId = function(vnetid)
        local data = exports["quantum_garage"]:getVehicleData(vnetid)
        if data then
            return data.user_id
        end
        return nil
    end,

    isHandcuffed = function()
        return quantum.isHandcuffed()
    end,

    getGloveSize = function(vname)
        return quantum.vehicleGlove(vname)
    end,
}
