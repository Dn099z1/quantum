local srv = {}
Tunnel.bindInterface('Killsystem', srv)

local config = module('quantum_core','src/configuration/cfgKillsystem')

local cooldownKillSystem = {}

srv.playerDeath = function(weapon, killerSource, headShot)
    killerSource = parseInt(killerSource)
    local source = source
    local user_id = quantum.getUserId(source)	
    if (not cooldownKillSystem[user_id]) then
        cooldownKillSystem[user_id] = true
        if user_id and (source ~= killerSource) then
            local killer_id = quantum.getUserId(killerSource)
            if killer_id then
                local sPed, nPed = GetPlayerPed(source), GetPlayerPed(killerSource)
                if (not DoesEntityExist(sPed)) or (not DoesEntityExist(nPed)) then return; end;

                local victimCoord = GetEntityCoords(sPed)
                local killerCoord = GetEntityCoords(nPed)
                local weaponName = (config.weapons[weapon] and config.weapons[weapon]['name'] or 'Desconhecido')
                local killer_identity = quantum.getUserIdentity(killer_id)
                local victim_identity = quantum.getUserIdentity(user_id)
                
                quantum.webhook('KillSystem', '```prolog\n[ID]: '..killer_id..' - '..killer_identity.firstname..' \n[MATOU O ID]: '..user_id..' - '..victim_identity.firstname..' \n[ARMA]: '..weaponName..' [HASH]: '..weapon..'\n[LOCAL ASSASSINO]: '..tostring(killerCoord)..'\n[LOCAL VITIMA]: '..tostring(victimCoord)..'\n'..os.date('[DATA]: %d/%m/%y   [HORA]: %X')..'```')
                Citizen.SetTimeout(500, function() cooldownKillSystem[user_id] = false end)
                
                local admin = quantum.getUsersByPermission('staff.permissao')
                for l,w in pairs(admin) do
                    local player = quantum.getUserSource(parseInt(w))
                    if player then
                     
                    end
                end
            end
        end
    end
end