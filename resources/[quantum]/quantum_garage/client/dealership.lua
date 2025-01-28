local cli = {}
Tunnel.bindInterface('Dealership', cli)
local vSERVER = Tunnel.getInterface('Dealership')

local configTest = config.testdrive

Citizen.CreateThread(function()
    local dealerShip = config.dealership
    while (true) do
        local _idle = 1000
        local ped = PlayerPedId()
        local distance = #(GetEntityCoords(ped) - dealerShip)

        if (distance <= 10.0) then
            _idle = 1

            exports["inside-interaction"]:AddInteractionCoords(dealerShip, {
                checkVisibility = true,
                {
                    name = "dealership_interaction",
                    icon = "fa-solid fa-car",
                    label = "Abrir Concessionaria",
                    key = "E",
                    duration = 1000,
                    action = function()
                        if GetEntityHealth(ped) > 100 and not IsPedInAnyVehicle(ped) then
                            SetNuiFocus(true, true)
                            TriggerEvent('quantum_core:tabletAnim')
                            SendNUIMessage({
                                action = 'dealership',
                                cars = vSERVER.getStock()
                            })
                        else
                            print("Você não pode acessar o Dealership no momento.")
                        end
                    end
                }
            })
        else

        end

        Citizen.Wait(_idle)
    end
end)


RegisterNuiCallback('testDrive', function(data)
    vSERVER.testDrive(data.spawn)
end)

RegisterNuiCallback('buyCar', function(data)
    vSERVER.buyVehicle(data.spawn)
end)

local cooldown = 0
cli.startTest = function(spawn)
    DoScreenFadeOut(500)
    Wait(500)

    if IsWaypointActive() then
        DeleteWaypoint()
        Wait(3000)
    end

    local ped = PlayerPedId()
    local random = configTest[math.random(#configTest)]
    SetEntityCoords(ped, random.xyz)

    RequestModel(spawn)
    while not HasModelLoaded(spawn) do
        Wait(50)
    end

    local vehicle = CreateVehicle(spawn, random.xyz, random.w, false)
    SetModelAsNoLongerNeeded(spawn)
    SetPedIntoVehicle(ped, vehicle, -1)

    -- Pegar a placa do veículo e printar
    local plate = GetVehicleNumberPlateText(vehicle)
TriggerEvent('quantum_garage:lockpickUsage',plate)
    DoScreenFadeIn(500)
    TimeDealership(60)
    while (cooldown > 0 and IsPedInAnyVehicle(ped)) do
        DisableControlAction(0, 23, true)
        Text2D(0, 0.35, 0.95, 'O ~b~TESTE DRIVE~w~ TERMINA EM ~b~'..cooldown..' SEGUNDOS~w~', 0.4)
        Citizen.Wait(1)
    end
    cooldown = 0

    DoScreenFadeOut(500)
    Wait(500)

    DeleteEntity(vehicle)
    vSERVER.exitTestDrive()

    DoScreenFadeIn(500)
end


TimeDealership = function(time)
    if (cooldown > 0) then return; end;
    cooldown = time
    Citizen.CreateThread(function()
        while (cooldown > 0) do
            Citizen.Wait(1000)
            cooldown = (cooldown - 1)
        end
        cooldown = 0
    end)
end