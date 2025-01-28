Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')
quantum = Proxy.getInterface('quantum')
quantumClient = Tunnel.getInterface('quantum')

config = {}

config.permissions = {
    ['vippm.permissao'] = 'Vip Policia'
}

config.attachs = {
    ['Policia'] = {
        ['active'] = true,
        ['weapons'] = {
            ['WEAPON_COMBATPISTOL'] = {
                ['components'] = { 'COMPONENT_AT_PI_FLSH' }
            },
            ['WEAPON_COMBATPDW'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_SMALL', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SMG'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MACRO_02' }
            },
            ['WEAPON_PUMPSHOTGUN'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH' }
            },
            ['WEAPON_PUMPSHOTGUN_MK2'] = {
                ['components'] = { 'COMPONENT_AT_SIGHTS', 'COMPONENT_AT_SCOPE_SMALL_MK2', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_MUZZLE_08' }
            },
            ['WEAPON_CARBINERIFLE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_AR_AFGRIP', 'COMPONENT_AT_SCOPE_MEDIUM' }
            },
            ['WEAPON_CARBINERIFLE_MK2'] = {
                ['components'] = { 'COMPONENT_AT_MUZZLE_04', 'COMPONENT_AT_AR_AFGRIP_02', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM_MK2' }
            },
            ['WEAPON_SPECIALCARBINE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SNIPERRIFLE'] = {
                ['components'] = { 'COMPONENT_AT_SCOPE_MAX' }
            }
        },
        ['perm'] = nil
    },
    ['Fib'] = {
        ['active'] = true,
        ['weapons'] = {
            ['WEAPON_COMBATPISTOL'] = {
                ['components'] = { 'COMPONENT_AT_PI_FLSH' }
            },
            ['WEAPON_COMBATPDW'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_SMALL', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SMG'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MACRO_02' }
            },
            ['WEAPON_PUMPSHOTGUN'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH' }
            },
            ['WEAPON_PUMPSHOTGUN_MK2'] = {
                ['components'] = { 'COMPONENT_AT_SIGHTS', 'COMPONENT_AT_SCOPE_SMALL_MK2', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_MUZZLE_08' }
            },
            ['WEAPON_CARBINERIFLE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_AR_AFGRIP', 'COMPONENT_AT_SCOPE_MEDIUM' }
            },
            ['WEAPON_CARBINERIFLE_MK2'] = {
                ['components'] = { 'COMPONENT_AT_MUZZLE_04', 'COMPONENT_AT_AR_AFGRIP_02', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM_MK2' }
            },
            ['WEAPON_SPECIALCARBINE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SNIPERRIFLE'] = {
                ['components'] = { 'COMPONENT_AT_SCOPE_MAX' }
            }
        },
        ['perm'] = nil
    },
    ['Swat'] = {
        ['active'] = true,
        ['weapons'] = {
            ['WEAPON_COMBATPISTOL'] = {
                ['components'] = { 'COMPONENT_AT_PI_FLSH' }
            },
            ['WEAPON_COMBATPDW'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_SMALL', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SMG'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MACRO_02' }
            },
            ['WEAPON_PUMPSHOTGUN'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH' }
            },
            ['WEAPON_PUMPSHOTGUN_MK2'] = {
                ['components'] = { 'COMPONENT_AT_SIGHTS', 'COMPONENT_AT_SCOPE_SMALL_MK2', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_MUZZLE_08' }
            },
            ['WEAPON_CARBINERIFLE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_AR_AFGRIP', 'COMPONENT_AT_SCOPE_MEDIUM' }
            },
            ['WEAPON_CARBINERIFLE_MK2'] = {
                ['components'] = { 'COMPONENT_AT_MUZZLE_04', 'COMPONENT_AT_AR_AFGRIP_02', 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM_MK2' }
            },
            ['WEAPON_SPECIALCARBINE'] = {
                ['components'] = { 'COMPONENT_AT_AR_FLSH', 'COMPONENT_AT_SCOPE_MEDIUM', 'COMPONENT_AT_AR_AFGRIP' }
            },
            ['WEAPON_SNIPERRIFLE'] = {
                ['components'] = { 'COMPONENT_AT_SCOPE_MAX' }
            }
        },
        ['perm'] = nil
    }
}

config.training = {
    ['Policia'] = { 
        ['active'] = true,
        ['perm'] = nil
    },
    ['Fib'] = { 
        ['active'] = true,
        ['perm'] = nil
    },
    ['Swat'] = { 
        ['active'] = true,
        ['perm'] = nil
    }
}

config.arsenal = {
    ['Policia'] = {
        ['name'] = 'Arsenal Policia', ['description'] = 'Departamento de Operações Especiais',
        ['weapons'] = {
            ['cooldownWeapons'] = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao' },
            { ['spawn'] = 'weapon_pistol_mk2', ['name'] = 'Five-SeveN', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_combatpistol', ['name'] = 'Glock', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_smg_mk2', ['name'] = 'MP9', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatpdw', ['name'] = 'MPX', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_assaultsmg', ['name'] = 'M-TAR', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_pumpshotgun_mk2', ['name'] = 'Remington', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatshotgun', ['name'] = 'SPAS-12', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_carbinerifle_mk2', ['name'] = 'M4A4', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_militaryrifle', ['name'] = 'AUG', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_tacticalrifle', ['name'] = 'M16', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_sniperrifle', ['name'] = 'AWP', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
        },
        ['utilitarys'] =  {
            ['cooldownUtilitarys']  = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'radio', ['name'] = 'Rádio', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'spike', ['name'] = 'Spike', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'barreira', ['name'] = 'Barreira', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'mochila-pequena', ['name'] = 'Mochila Pequena', ['quantity'] = 1, ['perm'] = nil, price = 500 },
            { ['spawn'] = 'cone', ['name'] = 'Cone', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'celular', ['name'] = 'Celular', ['quantity'] = 1, ['perm'] = nil, price = 900 },
            { ['spawn'] = 'energetico', ['name'] = 'Energético', ['quantity'] = 1, ['perm'] = nil, price = 850, infinityBuy = true },
            { ['spawn'] = 'algema', ['name'] = 'Algema', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'colete-militar', ['name'] = 'Colete Militar', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            -- { ['spawn'] = 'gadget_parachute', ['name'] = 'Paraquedas', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_NIGHTSTICK', ['name'] = 'Cassetete', ['ammo'] = 0, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_STUNGUN', ['name'] = 'Taser', ['ammo'] = 0, ['perm'] = nil, price = 50 },
        },
        ['kits'] = {},
        ['canExtraAmmo'] = { 
            ['active'] = true, 
            ['quantity'] = { ['min'] = 50, ['max'] = 250 }, 
            ['perm'] = nil 
        },
        ['webhooks'] = {
            ['weapons'] = 'dndcwebhook/webhooks/1144487701572231260/OhjqS-c6N0SFySxbhRQ4ufvrOXgnCNUMeRFYabyw4OGKe7VgsXCKdku3pt23JAMJb4rz',
            ['utilitarys'] = 'dndcwebhook/webhooks/1144487883101716572/2XiVVPl2WBg2xG62MK-EuU4YFZjkN5kjSun0P-ecFvvQbd7-GQARocQDZZ-xzrOoXP1E',
            ['kits'] = 'dndcwebhook/webhooks/1144488253471330394/pzXdlIFTisu13914mrhXusOoVSDjfL7XWMPKfAsZhiIp-86DQ-V_lKtTckjamkQGaO-2',
            ['ammo'] = 'dndcwebhook/webhooks/1144488454936350780/gtySgevhYIFaNsqFJFxY8chBgQw24i5OC2FBCpy64S3gBrfKnIuoTb1X9-WJf6wdOBZc'
        }
    },

    ['Fib'] = {
        ['name'] = 'Arsenal Policia', ['description'] = 'Departamento de Operações Especiais',
        ['weapons'] = {
            ['cooldownWeapons'] = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao' },
            { ['spawn'] = 'weapon_pistol_mk2', ['name'] = 'Five-SeveN', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_combatpistol', ['name'] = 'Glock', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_smg_mk2', ['name'] = 'MP9', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatpdw', ['name'] = 'MPX', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_assaultsmg', ['name'] = 'M-TAR', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_pumpshotgun_mk2', ['name'] = 'Remington', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatshotgun', ['name'] = 'SPAS-12', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_carbinerifle_mk2', ['name'] = 'M4A4', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_militaryrifle', ['name'] = 'AUG', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_tacticalrifle', ['name'] = 'M16', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_sniperrifle', ['name'] = 'AWP', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
        },
        ['utilitarys'] =  {
            ['cooldownUtilitarys']  = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'radio', ['name'] = 'Rádio', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'spike', ['name'] = 'Spike', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'barreira', ['name'] = 'Barreira', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'mochila-pequena', ['name'] = 'Mochila Pequena', ['quantity'] = 1, ['perm'] = nil, price = 500 },
            { ['spawn'] = 'cone', ['name'] = 'Cone', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'celular', ['name'] = 'Celular', ['quantity'] = 1, ['perm'] = nil, price = 900 },
            { ['spawn'] = 'energetico', ['name'] = 'Energético', ['quantity'] = 1, ['perm'] = nil, price = 850, infinityBuy = true },
            { ['spawn'] = 'algema', ['name'] = 'Algema', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'colete-militar', ['name'] = 'Colete Militar', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            -- { ['spawn'] = 'gadget_parachute', ['name'] = 'Paraquedas', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_NIGHTSTICK', ['name'] = 'Cassetete', ['ammo'] = 0, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_STUNGUN', ['name'] = 'Taser', ['ammo'] = 0, ['perm'] = nil, price = 50 },
        },
        ['kits'] = {},
        ['canExtraAmmo'] = { 
            ['active'] = true, 
            ['quantity'] = { ['min'] = 50, ['max'] = 250 }, 
            ['perm'] = nil 
        },
        ['webhooks'] = {
            ['weapons'] = 'dndcwebhook/webhooks/1144487701572231260/OhjqS-c6N0SFySxbhRQ4ufvrOXgnCNUMeRFYabyw4OGKe7VgsXCKdku3pt23JAMJb4rz',
            ['utilitarys'] = 'dndcwebhook/webhooks/1144487883101716572/2XiVVPl2WBg2xG62MK-EuU4YFZjkN5kjSun0P-ecFvvQbd7-GQARocQDZZ-xzrOoXP1E',
            ['kits'] = 'dndcwebhook/webhooks/1144488253471330394/pzXdlIFTisu13914mrhXusOoVSDjfL7XWMPKfAsZhiIp-86DQ-V_lKtTckjamkQGaO-2',
            ['ammo'] = 'dndcwebhook/webhooks/1144488454936350780/gtySgevhYIFaNsqFJFxY8chBgQw24i5OC2FBCpy64S3gBrfKnIuoTb1X9-WJf6wdOBZc'
        }
    },

    ['Swat'] = {
        ['name'] = 'Arsenal Swat', ['description'] = 'Departamento de Operações Especiais',
        ['weapons'] = {
            ['cooldownWeapons'] = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao' },
            { ['spawn'] = 'weapon_pistol_mk2', ['name'] = 'Five-SeveN', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_combatpistol', ['name'] = 'Glock', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_smg_mk2', ['name'] = 'MP9', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatpdw', ['name'] = 'MPX', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_assaultsmg', ['name'] = 'M-TAR', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_pumpshotgun_mk2', ['name'] = 'Remington', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_combatshotgun', ['name'] = 'SPAS-12', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'weapon_carbinerifle_mk2', ['name'] = 'M4A4', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_militaryrifle', ['name'] = 'AUG', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_tacticalrifle', ['name'] = 'M16', ['ammo'] = 250, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'weapon_sniperrifle', ['name'] = 'AWP', ['ammo'] = 250, ['perm'] = 'vippm.permissao', price = 50 },
        },
        ['utilitarys'] =  {
            ['cooldownUtilitarys']  = { ['time'] = 30, ['noCooldown'] = 'vippm.permissao', price = 50 },
            { ['spawn'] = 'radio', ['name'] = 'Rádio', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'spike', ['name'] = 'Spike', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'barreira', ['name'] = 'Barreira', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'cone', ['name'] = 'Cone', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['spawn'] = 'celular', ['name'] = 'Celular', ['quantity'] = 1, ['perm'] = nil, price = 900 },
            { ['spawn'] = 'energetico', ['name'] = 'Energético', ['quantity'] = 1, ['perm'] = nil, price = 850 },
            { ['spawn'] = 'colete-militar', ['name'] = 'Colete Militar', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            -- { ['spawn'] = 'gadget_parachute', ['name'] = 'Paraquedas', ['quantity'] = 1, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_NIGHTSTICK', ['name'] = 'Cassetete', ['ammo'] = 0, ['perm'] = nil, price = 50 },
            { ['type'] = 'arma', ['spawn'] = 'WEAPON_STUNGUN', ['name'] = 'Taser', ['ammo'] = 0, ['perm'] = nil, price = 50 },
        },
        ['kits'] = {},
        ['canExtraAmmo'] = { 
            ['active'] = true, 
            ['quantity'] = { ['min'] = 50, ['max'] = 250 }, 
            ['perm'] = nil 
        },
        ['webhooks'] = {
            ['weapons'] = 'dndcwebhook/webhooks/1141425927121809478/oWQ_11ZCbQJ-5bPqpN7CiqwzLukt3EP07zmtz_N18nEPlkIQ-M3IiZXEQbYbhUfXccU_',
            ['utilitarys'] = 'dndcwebhook/webhooks/1141425927121809478/oWQ_11ZCbQJ-5bPqpN7CiqwzLukt3EP07zmtz_N18nEPlkIQ-M3IiZXEQbYbhUfXccU_',
            ['kits'] = 'dndcwebhook/webhooks/1141425927121809478/oWQ_11ZCbQJ-5bPqpN7CiqwzLukt3EP07zmtz_N18nEPlkIQ-M3IiZXEQbYbhUfXccU_',
            ['ammo'] = 'dndcwebhook/webhooks/1141425927121809478/oWQ_11ZCbQJ-5bPqpN7CiqwzLukt3EP07zmtz_N18nEPlkIQ-M3IiZXEQbYbhUfXccU_'
        }
    }
}

config.locs = {
    { 
        ['coord'] = vector3(850.8264, -1310.136, 26.48279), 
        ['config'] = 'Swat', 
        ['ped'] = {
            ['coord'] = vector4(850.8, -1311.719, 26.48279, 0),
            ['skin'] = 's_m_m_fiboffice_01'
        },
        ['perm'] = 'policia.permissao'
    },
    { 
        ['coord'] = vector3(2521.345, -336.7253, 101.8857), 
        ['config'] = 'Fib', 
        ['ped'] = {
            ['coord'] = vector4(2522.624, -337.8593, 101.8857, 42.51968),
            ['skin'] = 's_m_m_fiboffice_01'
        },
        ['perm'] = 'policia.permissao'
    },
    { 
        ['coord'] = vector3(484.1802, -1002.053, 25.72449), 
        ['config'] = 'Policia', 
        ['ped'] = {
            ['coord'] = vector4(484.5758, -1003.688, 25.72449, 2.834646),
            ['skin'] = 's_m_m_fiboffice_01'
        },
        ['perm'] = 'policia.permissao'
    }
}