Citizen.CreateThread(function()
    NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
end)

local threadStarted = false
local deathTimer = 0

local threadSurvival = function()
    if (threadStarted) then return; end;
    threadStarted = true

    local getDeathTimer = config.general.deathTimer
    survivalTimer(getDeathTimer)

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    Citizen.CreateThread(function()
        SendNUIMessage({ action = 'show', value = true })
        LocalPlayer.state.Hud = false

        NetworkSetFriendlyFireOption(false)
        SetEntityHealth(ped, 0)
        vRPserver.updateHealth(0)

        TriggerEvent('tksInterface:off')
        TriggerEvent('radio:outServers')
        
        while (threadStarted) do
            ped = PlayerPedId()
            pedCoords = GetEntityCoords(ped)

            if (GetEntityHealth(ped) <= 100) then
                if (GetEntityAttachedTo(ped) ~= 0) then
                    if (not IsEntityPlayingAnim(ped, 'mp_sleep', 'sleep_loop', 3) and not IsPedInAnyVehicle(ped)) then
                        vRP.playAnim(false, { 'mp_sleep', 'sleep_loop' }, true)
                    elseif (IsPedInAnyVehicle(ped)) then
                        SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0)
                    end
                else
                    if (not IsPedRunningRagdollTask(ped)) then SetPedToRagdoll(ped, 5000, 5000,0, 0, 0, 0); end;
                    ResetPedRagdollTimer(ped)
                end

                if (deathTimer > 0) then
                    SendNUIMessage({ action = 'timer', value = deathTimer })
                else
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = 'timer', value = 0 })
                end

                disableActions()
            else
                deathTimer = 0
                threadStarted = false
                
                TriggerEvent('tksInterface:on')
                SetNuiFocus(false, false)
                SendNUIMessage({ action = 'show', value = false })
                NetworkSetFriendlyFireOption(true)
            end
            Citizen.Wait(4)
        end
    end)

    Citizen.CreateThread(function()
        local waiting = 0
        while (deathTimer > 0) do
            Citizen.Wait(1000)
            if (deathTimer ~= 0) then TriggerServerEvent('death:saveTimer', deathTimer); end;
            
            if (waiting == 10) then
                if (IsEntityDead(ped)) then
                    NetworkResurrectLocalPlayer(pedCoords.x, pedCoords.y, pedCoords.z, true, true, false)
                    SetEntityInvincible(ped, true)
                    SetEntityHealth(ped, 100)
                    vRPserver.updateHealth(100)
                end
            else
                waiting = (waiting + 1)
            end
        end
    end)
end

disableActions = function()
    DisablePlayerFiring(PlayerPedId(), true)
    DisableControlAction(0, 21, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 29, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 56, true)
    DisableControlAction(0, 58, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 137, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 166, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 168, true)
    DisableControlAction(0, 169, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 177, true)
    DisableControlAction(0, 182, true)
    DisableControlAction(0, 187, true)
    DisableControlAction(0, 188, true)
    DisableControlAction(0, 189, true)
    DisableControlAction(0, 190, true)
    DisableControlAction(0, 243, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 268, true)
    DisableControlAction(0, 269, true)
    DisableControlAction(0, 270, true)
    DisableControlAction(0, 271, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 311, true)
    DisableControlAction(0, 344, true)
end

survivalTimer = function(time)
    Citizen.CreateThread(function()
        deathTimer = time
        while (deathTimer > 0) do
            Citizen.Wait(1000)
            deathTimer = (deathTimer - 1)
        end
        deathTimer = 0
    end)
end



AddEventHandler('gameEventTriggered', function (name, args)
	if (name == 'CEventNetworkEntityDamage')  then
		local ped = PlayerPedId()
		if (args[1] == ped and args[6] == 1) then 
            if (GetEntityHealth(ped) <= 100) then threadSurvival(); end;
		end
	end
end) 

Citizen.CreateThread(function()
    while (true) do
        if (not threadStarted) and LocalPlayer.state.Active then
            if (GetEntityHealth(PlayerPedId()) <= 100) then threadSurvival(); end;
        end
        Citizen.Wait(1000)
    end
end)

exports('setDeathTime', function(value) deathTimer = parseInt(value) end)

exports('isDied', function() return threadStarted end)

reviveSurvival = function()
    TriggerServerEvent('death:saveTimer', configGeneral.deathTimer)

    local ped = PlayerPedId()

    if (IsEntityDead(ped)) then
        local pCDS = GetEntityCoords(ped)
		NetworkResurrectLocalPlayer(pCDS.x, pCDS.y, pCDS.z, true, true, false)
    end

    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 0)

    vRPserver.updateHealth(200)
    vRPserver.updateArmour(0)

    SetEntityInvincible(ped, false)
    ClearPedDamageDecalByZone(ped, 0, 'ALL')
    ClearPedDamageDecalByZone(ped, 1, 'ALL')
    ClearPedDamageDecalByZone(ped, 2, 'ALL')
    ClearPedDamageDecalByZone(ped, 3, 'ALL')
    ClearPedDamageDecalByZone(ped, 4, 'ALL')
    ClearPedDamageDecalByZone(ped, 5, 'ALL')
    ClearPedBloodDamage(ped)
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
    ResetPedMovementClipset(GetPlayerPed(-1), 0)

    TriggerEvent('tksInterface:on')
end
exports('reviveSurvival', reviveSurvival)

respawnSurvival = function()
    local ped = PlayerPedId()
    if (vSERVER.clearAfterDie()) then
        Citizen.Wait(1000)
        DoScreenFadeOut(1000)
		Citizen.Wait(1000)

        FreezeEntityPosition(ped, true)
        SetEntityCoords(ped, configGeneral.spawn.xyz)
        SetEntityHeading(ped, configGeneral.spawn.w)

        Citizen.SetTimeout(5000, function()
            Citizen.Wait(1000)
            DoScreenFadeIn(1000)

            reviveSurvival()
            FreezeEntityPosition(ped, false)
            TriggerEvent('tksInterface:on')
        end)
    end
end

----------------------------------------------------------------
-- Callback's
----------------------------------------------------------------
RegisterNUICallback('revive', function(data, cb)
    respawnSurvival()

    cb('Ok')
end)