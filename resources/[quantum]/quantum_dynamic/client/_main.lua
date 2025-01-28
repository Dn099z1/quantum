sDynamic = Tunnel.getInterface('quantum_dynamic')
cDynamic = {}
Tunnel.bindInterface('quantum_dynamic', cDynamic)
quantum = Proxy.getInterface('quantum')


RegisterKeyMapping("openDynamic", "Abrir ações possíveis", 'KEYBOARD', "F9")
RegisterCommand("openDynamic", function()
    local ped = PlayerPedId()
    if (GetEntityHealth(ped) > 100 and not quantum.isHandcuffed()) then
        cDynamic.openOrUpdateNui()
    end
end)
function openOrUpdateNui()
    cDynamic.openOrUpdateNui()
end
cDynamic.openOrUpdateNui = function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        favorites = sDynamic.getFavorites(),
        clothes = exports.quantum_system:getClothesPresets(),
        animations = exports.quantum_core:getAllAnimations(),
        permissions = {
            hospital = sDynamic.checkPermission('hospital.permissao'),
            policia = sDynamic.checkPermission('policia.permissao'),
            staff = sDynamic.checkPermission('staff.permissao'),
            mecanica = sDynamic.checkPermission('quantummecanica.permissao'),
            juridico = sDynamic.checkPermission('juridico.permissao'),
        }
    })
end

RegisterNuiCallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('handleAction', function(data)
    if (data.side == 'client') then
        TriggerEvent('quantum_interactions:'..data.action, data.value)
    else
        TriggerServerEvent('quantum_interactions:'..data.action, data.value)
    end
end)

RegisterNuiCallback('setFavorite', function(data)
    sDynamic.setFavorite(data.action)
end)

RegisterNuiCallback('deleteFavorite', function(data)
    sDynamic.deleteFavorite(data.action)
end)


RegisterNUICallback('openIdentity', function()
    
    TriggerEvent('openIdentity')
end)
