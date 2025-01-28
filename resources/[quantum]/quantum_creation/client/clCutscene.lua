local pedsList = {
    [0] = 'MP_Plane_Passenger_1',
    [1] = 'MP_Plane_Passenger_2',
    [2] = 'MP_Plane_Passenger_3',
    [3] = 'MP_Plane_Passenger_4',
    [4] = 'MP_Plane_Passenger_5',
    [5] = 'MP_Plane_Passenger_6',
    [6] = 'MP_Plane_Passenger_7'
}

local ComponentsTypes = { 
    [0] = { 
        [0] = 21, 
        [1] = 13, 
        [2] = 15, 
        [3] = 14, 
        [4] = 18, 
        [5] = 27, 
        [6] = 16 
    },
    [1] = { 
        [0] = 0, 
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0 
    },
    [2] = { 
        [0] = 9, 
        [1] = 5, 
        [2] = 1, 
        [3] = 5, 
        [4] = 15, 
        [5] = 7, 
        [6] = 15
    },
    [3] = {
        [0] = 1, 
        [1] = 1, 
        [2] = 1, 
        [3] = 3, 
        [4] = 15, 
        [5] = 11, 
        [6] = 3 
    },
    [4] = {
        [0] = 9, 
        [1] = 10, 
        [2] = 0, 
        [3] = 1, 
        [4] = 2, 
        [5] = 4, 
        [6] = 5 
    },
    [5] = { 
        [0] = 0, 
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0 
    },
    [6] = {
        [0] = 4, 
        [1] = 10, 
        [2] = 1 ,
        [3] = 11, 
        [4] = 4, 
        [5] = 13, 
        [6] = 2 
    },
    [7] = {
        [0] = 0, 
        [1] = 11, 
        [2] = 0, 
        [3] = 0, 
        [4] = 4, 
        [5] = 5, 
        [6] = 0
    },
    [8] = {
        [0] = 15, 
        [1] = 13, 
        [2] = 2, 
        [3] = 2, 
        [4] = 3, 
        [5] = 3, 
        [6] = 2 
    },
    [9] = { 
        [0] = 0, 
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0 
    },
    [10] = { 
        [0] = 0, 
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0 
    },
    [11] = { 
        [0] = 10, 
        [1] = 10, 
        [2] = 6, 
        [3] = 3, 
        [4] = 4, 
        [5] = 2, 
        [6] = 3
    }
}

RegisterNetEvent('introCinematic:start')
AddEventHandler('introCinematic:start', function()
    local playerId = PlayerPedId()
    
    -- Prepare and trigger intro music
    PrepareMusicEvent('FM_INTRO_START')
    TriggerMusicEvent('FM_INTRO_START') 

    -- Wait for a moment to ensure the music is playing
    Citizen.Wait(500)
    
    -- Set weather type
    SetWeatherTypeNow('EXTRASUNNY')

    -- Start fade out and wait for the transition
    DoScreenFadeOut(500)

    
    -- Trigger any necessary events, like HUD toggle or interface
    TriggerEvent('quantum_hud:toggleHud', true)
    TriggerEvent('tksInterface:on')
    
    -- Wait a moment and then fade in

    DoScreenFadeIn(500)

    -- Teleport the player to the designated spawn location
    quantum.teleport(generalConfig.spawnLocation.xyz)
    SetEntityHeading(playerId, generalConfig.spawnLocation.w)

    -- Stop the music after the intro
    PrepareMusicEvent('AC_STOP')
    TriggerMusicEvent('AC_STOP')
end)


ClearPedProps = function(ped)
    for i = 0, 8, 1 do
        ClearPedProp(ped, i)
    end
end

HandleRandomPeds = function(ped)
    SetPedRandomComponentVariation(ped, 0) 
    ClearPedProps(ped)
end

HandlePassengersClothes = function(ped, pedIdx)
    if (pedIdx >= 0 and pedIdx <= 6) then HandleRandomPeds(ped) end
end

RegisterNUICallback('closeLamarScreen', function()
    SetNuiFocus(false, false)
    TriggerEvent('quantum_hud:toggleHud', true)
    TriggerEvent('tksInterface:on')
end)