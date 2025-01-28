local config = module('quantum_core','src/configuration/cfgPed')

local localPeds = {}
CreateThread(function()
    local idle = 1000
    local pedDensity = 0.2 -- 0.0 (nenhum NPC) até 1.0 (densidade padrão)
    local vehicleDensity = 0.2 -- 0.0 (nenhum veículo) até 1.0 (densidade padrão)
    local parkedVehicleDensity = 0.1 -- Densidade de veículos estacionados
    
    while true do
        idle = 0
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity)
        SetVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetRandomVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(parkedVehicleDensity)

        -- Remove veículos ou pedestres à força em áreas específicas (opcional)
        -- ClearAreaOfPeds(x, y, z, radius, false)
        -- ClearAreaOfVehicles(x, y, z, radius, false, false, false, false, false)

        Wait(idle) -- Espera para evitar sobrecarga da thread
    end
end)
Citizen.CreateThread(function()
    while (true) do
        local ped = PlayerPedId()
        for k, v in pairs(config.peds) do
            local distance = #(GetEntityCoords(ped) - v.coord.xyz)
            if (distance <= 25) then
                if (not localPeds[k]) then
                    local hash = v.hash
                    RequestModel(hash)
                    while (not HasModelLoaded(hash)) do
						RequestModel(hash)
						Citizen.Wait(10)
					end

                    localPeds[k] = CreatePed(4, hash, v.coord.x, v.coord.y, v.coord.z - 1, v.coord.w, false, false)
                    SetEntityInvincible(localPeds[k], true)
					FreezeEntityPosition(localPeds[k], true)
					SetBlockingOfNonTemporaryEvents(localPeds[k], true)
                    SetModelAsNoLongerNeeded(mHash)

                    if (v.anim) then
                        local idle = v.anim[1]
                        local dict = v.anim[2]

                        RequestAnimDict(idle)
						while (not HasAnimDictLoaded(idle)) do
							RequestAnimDict(idle)
							Citizen.Wait(10)
						end
						TaskPlayAnim(localPeds[k], idle, dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                    end
                else
                    if (v.anim) then
                        local idle = v.anim[1]
                        local dict = v.anim[2]
                        if (not IsEntityPlayingAnim(localPeds[k], idle, dict, 3 )) then
                            TaskPlayAnim(localPeds[k], idle, dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                        end
                    end
                end
            else
                if (localPeds[k]) then
					SetEntityAsMissionEntity(localPeds[k], false, false)
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
            end
        end
        Citizen.Wait(1500)
    end
end)