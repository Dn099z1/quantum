local config = module('quantum_core', 'src/configuration/cfgAnimations')
local configAnimations = config.animations

RegisterCommand('e', function(source, args)
    local _source = source
    local _userId = quantum.getUserId(source)
    if (GetEntityHealth(GetPlayerPed(_source)) > 100) then
        local animation = configAnimations.animations[args[1]]
        if (animation) then
            if (quantum.checkPermissions(_userId, animation.perm)) then
                TriggerClientEvent('quantum_animations:setAnim', _source, args[1])
            end
        end
    end
end)

RegisterCommand('ec', function(source, args)
    local _source = source
    local _userId = quantum.getUserId(source)
    if (GetEntityHealth(GetPlayerPed(_source)) > 100) then
        local animation = configAnimations.shared[args[1]]
        if (animation) then
            if (quantum.checkPermissions(_userId, animation.perm)) then
                local nSource = quantumClient.getNearestPlayer(source, 2)
                if (nSource) then
                    if (GetEntityHealth(GetPlayerPed(nSource)) > 100) then 
                        local identity = quantum.getUserIdentity(_userId)
                        local request = exports.quantum_hud:request(nSource, 'Você deseja aceitar a animação '..args[1]:upper()..' de '..identity.firstname..' '..identity.lastname..'?', 30000)
                        if (request) then
                            TriggerClientEvent('quantum_animations:setAnimShared', _source, args[1], nSource)
                            TriggerClientEvent('quantum_animations:setAnimShared2', nSource, animation.otherAnim, _source)
                        end
                    end
                end
            end
        end
    end
end)

RegisterCommand('andar', function(source, args)
    local user_id = quantum.getUserId(source)
    if (user_id and args[1]) then
        local anim = configAnimations.walkAnim[parseInt(args[1])]
        if (anim) and quantum.checkPermissions(user_id, anim.perm) then
            TriggerClientEvent('anim-setWalking', source, anim.anim)
        end
    end
end)

RegisterCommand('ex', function(source, args)
    local user_id = quantum.getUserId(source)
    if (user_id and args[1]) then
        local anim = configAnimations.expression[args[1]]
        if (anim) and quantum.checkPermissions(user_id, anim.perm) then
            TriggerClientEvent('anim-setExpression', source, anim.anim)
        end
    end
end)


RegisterNetEvent('quantum_animation:sharedServer', function(target)
    TriggerClientEvent('quantum_animation:sharedClearAnimation', target)
end)

RegisterNetEvent('quantum_interactions:execAnimation', function(value)
    local _source = source
    local _userId = quantum.getUserId(source)
    if (GetEntityHealth(GetPlayerPed(_source)) > 100) then
        if (value[1] == 'shared') then
            local animation = configAnimations.shared[value[2]]
            if (animation) then
                if (quantum.checkPermissions(_userId, animation.perm)) then
                    local nSource = quantumClient.getNearestPlayer(_source, 2)
                    if (nSource) then
                        if (GetEntityHealth(GetPlayerPed(nSource)) > 100) then 
                            local identity = quantum.getUserIdentity(_userId)
                            local request = exports.quantum_hud:request(nSource, 'Você deseja aceitar a animação '..value[2]:upper()..' de '..identity.firstname..' '..identity.lastname..'?', 30000)
                            if (request) then
                                TriggerClientEvent('quantum_animations:setAnimShared', _source, value[2], nSource)
                                TriggerClientEvent('quantum_animations:setAnimShared2', nSource, animation.otherAnim, _source)
                            end
                        end
                    end
                end
            end
        else
            local animation = configAnimations.animations[value[2]]
            if (animation) then
                if (quantum.checkPermissions(_userId, animation.perm)) then
                    TriggerClientEvent('quantum_animations:setAnim', _source, value[2])
                end
            end
        end  
    end
end)