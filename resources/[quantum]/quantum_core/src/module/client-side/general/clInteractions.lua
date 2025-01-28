cacheInteractions = {}

local cli = {}
Tunnel.bindInterface('Interactions', cli) 
local vSERVER = Tunnel.getInterface('Interactions')


local setPed = {
    [GetHashKey('mp_m_freemode_01')] = {
        _Handcuff = { 7, 41, 0, 2 }
    },
    [GetHashKey('mp_f_freemode_01')] = {
        _Handcuff = {  7, 25, 0, 2 }
    }
}


cacheInteractions['quantum:attach:src'] = nil
cacheInteractions['quantum:attach:active'] = false

RegisterNetEvent('quantum:attach', function(_source, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, rotationOrder, syncRot)
    cacheInteractions['quantum:attach:src'] = _source
    cacheInteractions['quantum:attach:active'] = (not cacheInteractions['quantum:attach:active'])
    local ped = PlayerPedId()
	if (cacheInteractions['quantum:attach:active']) then
		local player = GetPlayerFromServerId(cacheInteractions['quantum:attach:src'])
		if (player > -1) then
			AttachEntityToEntity(ped, GetPlayerPed(player), boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, rotationOrder, syncRot)
		end
	else
		DetachEntity(ped, true, false)
	end
end)

RegisterNetEvent('quantum_interactions:algemas', function(action)
    local ped = PlayerPedId()
    if (action == 'colocar') then
        local Handcuff = setPed[GetEntityModel(ped)]
        if (Handcuff) and Handcuff._Handcuff then Handcuff = Handcuff._Handcuff SetPedComponentVariation(ped, Handcuff[1], Handcuff[2], Handcuff[3], Handcuff[4]); end;
    else
        SetPedComponentVariation(ped, 7, 0, 0, 2)
    end
end)

RegisterKeyMapping('+carregar', 'Interação - Carregar', 'keyboard', 'H')
RegisterCommand('+carregar', function() if (not IsPedInAnyVehicle(PlayerPedId())) then TriggerServerEvent('quantum_interactions:carregar') end; end)

cacheInteractions['carregar:src'] = nil
cacheInteractions['carregar:active'] = false

RegisterNetEvent('carregar', function(_source)
	LocalPlayer.state.BlockTasks = true
    cacheInteractions['carregar:src'] = _source
    cacheInteractions['carregar:active'] = (not cacheInteractions['carregar:active'])
    local ped = PlayerPedId()
	if (cacheInteractions['carregar:active']) then
		local player = GetPlayerFromServerId(cacheInteractions['carregar:src'])
		if (player > -1) then
			AttachEntityToEntity(ped, GetPlayerPed(player), 4103, -0.65816, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end
	else
		LocalPlayer.state.BlockTasks = false
		DetachEntity(ped, true, false)
	end
end)

local PlayerData = {}
PlayerData['temp:wins'] = false

RegisterCommand('wins', function()
	local vehicle = quantum.getNearestVehicle(5)
	if (IsEntityAVehicle(vehicle)) then
		PlayerData['temp:wins'] = (not PlayerData['temp:wins'])
		TriggerServerEvent('trywins', VehToNet(vehicle), PlayerData['temp:wins'])
	end
end)

RegisterNetEvent('quantum_interactions:carWins', function()
    local vehicle = quantum.getNearestVehicle(5)
	if (IsEntityAVehicle(vehicle)) then
		PlayerData['temp:wins'] = (not PlayerData['temp:wins'])
		TriggerServerEvent('trywins', VehToNet(vehicle), PlayerData['temp:wins'])
	end
end)

RegisterNetEvent('syncwins', function(index, open)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				if open then
					RollDownWindow(v,0)
					RollDownWindow(v,1)
					RollDownWindow(v,2)
					RollDownWindow(v,3)
				else
					RollUpWindow(v,0)
					RollUpWindow(v,1)
					RollUpWindow(v,2)
					RollUpWindow(v,3)
				end
			end
		end
	end
end)

RegisterCommand('seat', function(source, args)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
	if (IsEntityAVehicle(vehicle) and IsPedInAnyVehicle(ped)) then
		local seat = 0
		if (parseInt(args[1]) <= 1) then
			seat = -1
		else
			seat = parseInt(args[1])-2
		end
		if (IsVehicleSeatFree(vehicle, seat)) then
			SetPedIntoVehicle(ped, vehicle, seat)
		else
			TriggerEvent('notify', 'Seat', 'Este <b>assento</b> está ocupado.')
		end
	else
		TriggerEvent('notify', 'Seat', 'Você não está dentro de um <b>veículo</b>.')
	end
end)

RegisterCommand('doors', function(source, args)
	local vehicle = quantum.getNearestVehicle(7.0)
	if (IsEntityAVehicle(vehicle)) then
		TriggerServerEvent('trydoors', VehToNet(vehicle), parseInt(args[1]))
	end
end)

RegisterNetEvent('quantum_interactions:carDoors', function(value)
    local vehicle = quantum.getNearestVehicle(7.0)
	if (IsEntityAVehicle(vehicle)) then
		TriggerServerEvent('trydoors', VehToNet(vehicle), value)
	end
end)

RegisterNetEvent('syncdoors', function(index, door)
	if (NetworkDoesNetworkIdExist(index)) then
		local v = NetToVeh(index)
		if (DoesEntityExist(v)) then
			if (IsEntityAVehicle(v)) then
				if (door == 1) then
					if (GetVehicleDoorAngleRatio(v, 0) == 0) then
						SetVehicleDoorOpen(v, 0, 0, 0)
					else
						SetVehicleDoorShut(v, 0, 0)
					end
				elseif (door == 2) then
					if (GetVehicleDoorAngleRatio(v, 1) == 0) then
						SetVehicleDoorOpen(v, 1, 0, 0)
					else
						SetVehicleDoorShut(v, 1, 0)
					end
				elseif (door == 3) then
					if (GetVehicleDoorAngleRatio(v, 2) == 0) then
						SetVehicleDoorOpen(v, 2, 0, 0)
					else
						SetVehicleDoorShut(v, 2, 0)
					end
				elseif (door == 4) then
					if (GetVehicleDoorAngleRatio(v, 3) == 0) then
						SetVehicleDoorOpen(v, 3, 0, 0)
					else
						SetVehicleDoorShut(v, 3, 0)
					end
                elseif (door == 5) then
                    if (GetVehicleDoorAngleRatio(v,5) == 0) then
                        SetVehicleDoorOpen(v,5,0,0)
                    else
                        SetVehicleDoorShut(v,5,0)
                    end
                elseif (door == 6) then
                    if (GetVehicleDoorAngleRatio(v,4) == 0) then
                        SetVehicleDoorOpen(v,4,0,0)
                    else
                        SetVehicleDoorShut(v,4,0)
                    end
				else
                    local isopen = (GetVehicleDoorAngleRatio(v, 0) and GetVehicleDoorAngleRatio(v, 1))
					if (isopen == 0) then
						SetVehicleDoorOpen(v, 0 ,0 ,0)
						SetVehicleDoorOpen(v, 1 ,0 ,0)
						SetVehicleDoorOpen(v, 2 ,0 ,0)
						SetVehicleDoorOpen(v, 3 ,0 ,0)
                        SetVehicleDoorOpen(v, 4, 0, 0)
                        SetVehicleDoorOpen(v, 5, 0, 0)
					else
						SetVehicleDoorShut(v, 0, 0)
						SetVehicleDoorShut(v, 1, 0)
						SetVehicleDoorShut(v, 2, 0)
						SetVehicleDoorShut(v, 3, 0)
                        SetVehicleDoorShut(v, 4, 0)
                        SetVehicleDoorShut(v, 5, 0)
					end
				end
			end
		end
	end
end)

local BlipsPerimetro = {}

RegisterNetEvent('BlipPerimetro', function(id, coords, distance, open)
	if (open) then
		BlipsPerimetro[id] = {}

		BlipsPerimetro[id][1] = AddBlipForRadius(coords, (distance + 0.0))
		SetBlipColour(BlipsPerimetro[id][1], 3)
		SetBlipAlpha(BlipsPerimetro[id][1], 90)
		SetBlipDisplay(BlipsPerimetro[id][1], 8)

		BlipsPerimetro[id][2] = AddBlipForCoord(coords)
		SetBlipSprite(BlipsPerimetro[id][2], 58)
		SetBlipAsShortRange(BlipsPerimetro[id][2], true)
		SetBlipColour(BlipsPerimetro[id][2], 0)
		SetBlipScale(BlipsPerimetro[id][2], 0.5)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Perímetro Fechado') 
		EndTextCommandSetBlipName(BlipsPerimetro[id][2])
	else
		RemoveBlip(BlipsPerimetro[id][1]) 
		RemoveBlip(BlipsPerimetro[id][2]) 
	end
end)




local Toogle = {
    ['Policia'] = { 
        blip = { name = 'Policia', view = { ['Policia'] = true, ['Paramedico'] = true } },
        clearWeapons = true,
        webhook = 'https://discord.com/api/webhooks/1144480658899619860/BZXGIS4sb1q9yagZJiMjkGauApmkPsIS_DcY0FiaLUZAa0oQPU6HG1xh0rVG61qARbPP',
        toggleCoords = {
            { coord = vector3(-2286.699, 356.0967, 174.5927), radius = 70 },
        }
    },
    ['Hospital'] = { 
        blip = { name = 'Paramedico', view = { ['Paramedico'] = true, ['Policia'] = true } },
        webhook = 'https://discord.com/api/webhooks/1144480825119871086/vIH1P9fCuI_d8D6rv2E0w-KCJ0tQLGXh-2r8swqBVSX4vV3elJJuT80Y-WMcdWj7Xt4S',
        toggleCoords = {
            { coord = vector3(-816.1978, -1229.103, 7.324585), radius = 70 },
        }
    },
    ['Deic'] = { 
        blip = { name = 'DEIC', view = { ['Paramedico'] = true, ['Policia'] = true, ['Deic'] = true } },
        clearWeapons = true,
        webhook = 'https://discord.com/api/webhooks/1141426122660261988/Qr_S_oy9DTpjdTPjeMAB7VRdmLtCnvzKnU09Js4sXW7gW9L_asrkqxA3K2C8wedVoUX1',
        toggleCoords = {
            { coord = vector3(480.5011, 4539.547, 79.96411), radius = 70 },
        }
    },
    ['quantumMecanica'] = { 
        toggleCoords = {
            { coord = vector3(138.1582, -3029.723, 7.02124), radius = 70 },
        }
    },
}


local currentToggle = nil

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearToggle = false
		local sleep = 1000
        for k, v in pairs(Toogle) do
            for _, pos in pairs(v.toggleCoords) do
                DrawMarker(1, pos.coord.x, pos.coord.y, pos.coord.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 100, 255, 100, false, true, 2, nil, nil, false)
    
                if #(playerCoords - pos.coord) <= pos.radius then
                    isNearToggle = true
					sleep = 2
                    currentToggle = { job = k, config = v }
              
                    TextFloating("Pressione ~INPUT_CONTEXT~ para alternar seu estado de trabalho.")
       
                    if IsControlJustPressed(0, 51) then 
                        vSERVER.ToggleJob(k, v)
                    end
                end
            end
        end

        if not isNearToggle then
            currentToggle = nil
        end

        Citizen.Wait(sleep)
    end
end)

