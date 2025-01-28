-- [ Quantum Development ]
-- Sistema de garagem feito e implementado por dnzxdevop ❤
-- Optimized by dnzxdevop ❤  (Faço tudo nessa merda)

local vSERVER = Tunnel.getInterface('Enter')
local garagesConfig = config.garages
local teleportConfig = {
    { 
        entry = {x = -1606.088, y = -828.6989, z = 10.0542},  
        exit = {x = 1203.666, y = -2268.382, z = -47.13403},     
        interior = {x = 1220.133, y = -2277.844, z = -50.000},
        type = 'car'
    },
    { 
        entry = {x = 35.18242, y = -905.0022, z = 30.81323},  
        exit = {x = 531.6528, y = -2637.692, z = -49.00439},     
        interior = {x = 531.6528, y = -2637.692, z = -49.00439},
        type = 'car'
    },
    { 
        entry = {x = 39.0044, y = 6452.2, z = 31.4198},  
        exit = {x = -1072.576, y = -62.57143, z = -94.59998},     
        interior = {x = -1072.576, y = -62.57143, z = -94.59998}, 
        type = 'car'
    },
    { 
        entry = {x = 1409.776, y = 3619.965, z = 34.89087},  
        exit = {x = 178.8, y = -1006.312, z = -99.01465},     
        interior = {x = 178.8, y = -1006.312, z = -99.01465},  
        type = 'car'
    },
}

getType = function()
    for _, config in ipairs(teleportConfig) do
        if config.type == 'car' then
            return 36
        elseif config.type == 'heli' then
            return 7
        end
    end
    return 36
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local closestEntry = nil
        local closestExit = nil
        local entryDistance = math.huge
        local exitDistance = math.huge
        
        for _, config in ipairs(teleportConfig) do
            local entryDist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, config.entry.x, config.entry.y, config.entry.z)
            if entryDist < entryDistance then
                entryDistance = entryDist
                closestEntry = config
            end

            local exitDist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, config.exit.x, config.exit.y, config.exit.z)
            if exitDist < exitDistance then
                exitDistance = exitDist
                closestExit = config
            end
        end
        local rotation = 30.0

        if closestEntry and entryDistance < 5.0 then
            sleep = 1
           DrawMarker(getType(), closestEntry.entry.x, closestEntry.entry.y, closestEntry.entry.z - 0.5,
                   0.0, 0.0, 0.0, rotation, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, 
                   false, false, 2, false, false, false, false)
            if entryDistance < 1.0 and IsControlJustPressed(0, 38) then
                TeleportPlayer(closestEntry.interior.x, closestEntry.interior.y, closestEntry.interior.z)
            end
        end

        local Dnzx = exports.quantum_garage:getGarageIndexByDistance()
        local garageConfig = garagesConfig[Dnzx]
        if garageConfig and closestExit and exitDistance < 5.0 then
            sleep = 1
            DrawMarker(24, closestExit.exit.x, closestExit.exit.y, closestExit.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, false, false, 2, false, false, false, false)
            if exitDistance < 1.0 and IsControlJustPressed(0, 38) then
                TeleportPlayer(garageConfig.leave.x, garageConfig.leave.y, garageConfig.leave.z)
            end
        end
        Citizen.Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(200)

        local Dnzx = exports.quantum_garage:getGarageIndexByDistance()
        local garageConfig = garagesConfig[Dnzx]

        -- Fixed by dnzx
        if vSERVER.checkHomeExists(Dnzx) or (garageConfig and garageConfig.permission and garageConfig.vehicles) then
            exports.quantum_garage:freeVehicleState()
        else
            -- relaxa mano acontece nada aqui naum, e se vc ta vendo isso, vc dumpou a cidade.
            -- a real é que nada acontece, isso aqui não tem logica, e é melhor assim.
            -- a vida não tem logica, por que programação deve ter? acho isso uma falta de respeito.
            -- vc ta grabado.
        end

        if garageConfig then
            local fixedExitCoords = garageConfig.leave
            local player = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(player, false)

            if vehicle ~= 0 then
                local vehicleState = exports.quantum_garage:verifyState()
                if not vehicleState then
                    local speed = GetEntitySpeed(vehicle)
                    if speed > 0.5 then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Wait(0)
                        end

                        SetEntityCoords(vehicle, fixedExitCoords.x, fixedExitCoords.y, fixedExitCoords.z, false, false, false, false)
                        SetEntityHeading(vehicle, GetEntityHeading(vehicle))
                        SetEntityInvincible(vehicle, true)
                        SetEntityAlpha(vehicle, 150, false)

                        local players = GetActivePlayers()
                        for _, otherPlayer in ipairs(players) do
                            local otherPed = GetPlayerPed(otherPlayer)
                            if otherPed ~= player then
                                local otherVehicle = GetVehiclePedIsIn(otherPed, false)
                                if otherVehicle ~= 0 then
                                    SetEntityNoCollisionEntity(vehicle, otherVehicle, true)
                                    SetEntityNoCollisionEntity(otherVehicle, vehicle, true)
                                end
                            end
                        end

                        DoScreenFadeIn(500)
                        while not IsScreenFadedIn() do
                            Wait(0)
                        end
                        Wait(5000)

                        ResetEntityAlpha(vehicle)
                        SetEntityInvincible(vehicle, false)

                        for _, otherPlayer in ipairs(players) do
                            local otherPed = GetPlayerPed(otherPlayer)
                            if otherPed ~= player then
                                local otherVehicle = GetVehiclePedIsIn(otherPed, false)
                                if otherVehicle ~= 0 then
                                    SetEntityNoCollisionEntity(vehicle, otherVehicle, false)
                                    SetEntityNoCollisionEntity(otherVehicle, vehicle, false)
                                end
                            end
                        end

                        exports.quantum_garage:freeVehicleState()
                    end
                end
            end
        end
    end
end)


function TeleportPlayer(x, y, z)
    local player = PlayerPedId()
    local vehicle = nil

    if IsPedInAnyVehicle(player, false) then
        vehicle = GetVehiclePedIsIn(player, false)
        local vehNet = NetworkGetNetworkIdFromEntity(vehicle)
        exports.quantum_garage:deleteVehicle(vehNet)
        SetEntityCoords(player, x, y, z, false, false, false, true)
        SetEntityHeading(player, GetEntityHeading(player))
    else
        SetEntityCoords(player, x, y, z, false, false, false, true)
    end

    if vehicle then
        -- print("Vehicle Network ID: " .. NetworkGetNetworkIdFromEntity(vehicle))
    else
        -- print("Player is not in a vehicle.")
    end
end
