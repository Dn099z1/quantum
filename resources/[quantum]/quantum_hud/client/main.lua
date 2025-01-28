Tunnel = module('quantum','lib/Tunnel')

cli = {}
Tunnel.bindInterface(GetCurrentResourceName(), cli)
srv = Tunnel.getInterface(GetCurrentResourceName())

hud = true
local currentTime = getTime()
updateTime(currentTime)


RegisterNetEvent('pma-voice:setTalkingMode',function(mode)
    SendNUIMessage({ method = 'updateVoice', data = mode })
end)

RegisterNetEvent('pma-voice:playerTalking', function(talking)
    SendNUIMessage({ method = "updateTalking", data = talking })
end)



RegisterNetEvent('pma-listners:setFrequency',function(radio)
    SendNUIMessage({ method = 'updateRadioChannel', data = radio })
end)

RegisterNetEvent('quantum_hud:updateVehicleHud',function(bool)
    SendNUIMessage({ method = 'updateHudVehicle', data = bool })
end)

RegisterNetEvent('quantum_hud:toggleHud',function(bool)
    SendNUIMessage({ method = 'updateHud', data = bool })
end)

TriggerEvent('quantum_hud:toggleHud',true)
RegisterNetEvent('quantum_system:gps', function()
    LocalPlayer.state.GPS = true
    DisplayRadar(true)
end)

RegisterNuiCallback('close', function()
    SetNuiFocus(false, false)
end)