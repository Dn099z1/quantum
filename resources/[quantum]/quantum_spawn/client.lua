vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local cam = nil

local model = GetHashKey('mp_m_freemode_01')

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
	if (not LocalPlayer.state.spawned) then
		local ped = PlayerPedId()
        local pCoord = GetEntityCoords(ped)

        SetEntityVisible(ped, false)
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(PlayerId(), true)

		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
        
        ped = PlayerPedId()

		RequestCollisionAtCoord(pCoord.x, pCoord.y, pCoord.z)
        SetEntityCoordsNoOffset(ped, pCoord.x, pCoord.y, pCoord.z, false, false, false, true)
        NetworkResurrectLocalPlayer(pCoord.x, pCoord.y, pCoord.z, GetEntityHeading(ped), true, true, false)

		SetPedDefaultComponentVariation(ped)
        ClearPedTasksImmediately(ped)

        local time = GetGameTimer()
        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        SetEntityCollision(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, true)

        ShutdownLoadingScreenNui()
        ShutdownLoadingScreen()
        DoScreenFadeIn(500)
        while (IsScreenFadingIn()) do
            Citizen.Wait(1)
        end

        SetBigmapActive(true, false)
	    SetBigmapActive(false, false)

        TriggerEvent('playerSpawned')
		LocalPlayer.state.spawned = true
	end
end)

local spawnCamera = nil

RegisterNetEvent('quantum_spawn:selector', function(bool, characters)
    if bool then
        TriggerEvent('quantum_hud:toggleHud', false)
        TriggerEvent('tksInterface:off')
        vSERVER.setDm()

        local ped = PlayerPedId()

        -- Coordenadas de spawn
        local x, y, z = 787.5692, 1282.024, 360.2944

        RequestCollisionAtCoord(x, y, z)
        NewLoadSceneStart(x, y, z, x, y, z + 50.0, 50.0, 0)

        while not HasCollisionLoadedAroundEntity(ped) or IsNetworkLoadingScene() do
            Wait(0)
        end

        SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
        SetEntityHeading(ped, 178.5827)
        Wait(100)
        
        SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)

        ExecuteCommand('e dancar80')

        spawnCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(spawnCamera, 787.0022, 1279.253, 361.2944)
        PointCamAtCoord(spawnCamera, x, y + 1.0, z + 1.0)
        SetCamActive(spawnCamera, true)
        RenderScriptCams(true, false, 0, true, true)

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'open',
            characterList = characters
        })
    end
end)

RegisterNUICallback('selectCharacter', function(data)
    local slot = data.index
    if slot then
        vSERVER.returnDm()

        -- Verifica se a câmera foi criada e destrói
        if spawnCamera then
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(spawnCamera, false)
            spawnCamera = nil
        end
        
        local ped = PlayerPedId()

        FreezeEntityPosition(ped, false)

        SetNuiFocus(false, false)

        TriggerEvent("CanX-SpawnSelector:Open")
        TriggerEvent('tksInterface:on')
    end
end)


RegisterNuiCallback('setSpawn', function(data)
    local index = data.index
    if (index) then
        local ped = PlayerPedId()

        SetNuiFocus(false, false)
        DoScreenFadeOut(500)
		Citizen.Wait(1500)

        if (index ~= 'lastLocation') then
            SetEntityCoords(ped, config.spawns[index].coord.xyz)
            SetEntityHeading(ped, config.spawns[index].coord.w)
        else
            local coord = vSERVER.getLastPosition()
            SetEntityCoords(ped, coord)
        end

        Citizen.Wait(1000)
        DoScreenFadeIn(500)

        if (DoesCamExist(cam)) then
            SetCamActive(cam, false)
            RenderScriptCams(false, true, 5000, true, true)
	        cam = nil
        end

        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(PlayerId(), false)
        
        LocalPlayer.state.spawnSelected = true
    end
end)

RegisterNuiCallback('close', function()
    SetNuiFocus(false, false)

    local ped = PlayerPedId()

   

    if (DoesCamExist(cam)) then
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 5000, true, true)
        cam = nil
    end

    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)
    SetNuiFocus(false, false)
            
    LocalPlayer.state.spawnSelected = true
end)