local Tunnel = module("quantum","lib/Tunnel")
local Proxy = module("quantum","lib/Proxy")
vRP = Proxy.getInterface("quantum")
tks = {}
Tunnel.bindInterface('quantum_interface', tks)

tks.ready = true

local hour = 0
local minute = 0
local month = ""
local dayOfMonth = 0

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
local beltLock = 0
local beltSpeed = 0
local beltVelocity = 0

local hunger = 100
local thirst = 100
local hudoff = false
local pauseBreak = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusHunger")
AddEventHandler("statusHunger",function(number)
	hunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusThirst")
AddEventHandler("statusThirst",function(number)
	thirst = parseInt(number)
end)




RegisterNetEvent("quantum_hud:updateBasics")
AddEventHandler("quantum_hud:updateBasics", function(rHunger, rThirst)
  hunger, thirst = rHunger, rThirst
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(10000)
        if hunger >= 85 then
            SetTimecycleModifier('spectator5')
			ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE',1.0)
            TriggerEvent('Notify', 'importante', 'Você precisa <b>comer</b> urgentemente.')
        elseif thirst >= 80 then
            SetTimecycleModifier('spectator5')
			ShakeGameplayCam('FAMILY5_DRUG_TRIP_SHAKE',1.0)
            TriggerEvent('Notify', 'importante', 'Você precisa <b>beber</b> urgentemente.')
        elseif hunger < 85 then
            if (LocalPlayer.state.FPS) then
                SetTimecycleModifier('cinema')
            else
                SetTimecycleModifier('default')
            end
            StopGameplayCamShaking()
        elseif thirst < 80 then
            if (LocalPlayer.state.FPS) then
                SetTimecycleModifier('cinema')
            else
                SetTimecycleModifier('default')
            end
            StopGameplayCamShaking()
        end
    end
end)

inCar = false
Citizen.CreateThread(function()
	while true do
		local hyper = 1000
		local ped = PlayerPedId()
		inCar = IsPedInAnyVehicle(ped, false)
	
		if inCar then 
			vehicle = GetVehiclePedIsIn(ped, false)
			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			local armour = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
	
			SendNUIMessage({
				action = "inCar",
				health = vida,
				armour = armour,
				stamina = stamina,
				hunger = parseInt(hunger),
				thirst = parseInt(thirst),
				hudoff = hudoff,
			})	
		end
		Citizen.Wait(hyper)	
	end
end)



local streetLast = 0
local flexDirection = "Norte"
Citizen.CreateThread(function()
	while true do
		local hyper = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped,false))
		local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"],coords["y"],coords["z"]))
		if heading >= 315 or heading < 45 then
			flexDirection = "Norte"
		elseif heading >= 45 and heading < 135 then
			flexDirection = "Oeste"
		elseif heading >= 135 and heading < 225 then
			flexDirection = "Sul"
		elseif heading >= 225 and heading < 315 then
			flexDirection = "Leste"
		end
		hours = GetClockHours()
		minutes = GetClockMinutes()
	
		if hours <= 9 then
			hours = "0"..hours
		end
	
		if minutes <= 9 then
			minutes = "0"..minutes
		end
		local horario = hours..":"..minutes

		SendNUIMessage({
			action = "horarios",
			time = horario,
			direction = flexDirection,
			street = streetName,
		})	

		Citizen.Wait(hyper)	
	end
end)

Citizen.CreateThread(function()
	while true do
		local hyper = 1000
		if inCar then 
			hyper = 0
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.605936)
			if IsVehicleDriveable(vehicle, 0) then
				local marcha = GetVehicleCurrentGear(vehicle)
				local fuel = GetVehicleFuelLevel(vehicle)
				local engine = GetVehicleEngineHealth(vehicle)

				carGear = GetVehicleCurrentGear(vehicle)
				rpm = GetVehicleCurrentRpm(vehicle)
				rpm = math.ceil(rpm * 10000, 2)
				vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)

				local farol = "off"
				local _,lights,highlights = GetVehicleLightsState(vehicle)
				if lights == 1 and highlights == 0 then 
					farol = "normal"
				elseif (lights == 1 and highlights == 1) or (lights == 0 and highlights == 1) then 
					farol = "alto"
				end
			
				local vehicleGear = GetVehicleCurrentGear(vehicle)
			
				if speed > 0 and vehicleGear == 0 then
					vehicleGear = 7
				end

				local tks = GetVehicleClass(vehicle)
				if beltLock == 1 or tks == 19 or tks == 8 or tks == 13 or tks == 15 or tks == 18 then
					DisplayRadar(true)
				else
					DisplayRadar(false)
				end

				

				SendNUIMessage({
					only = "updateSpeed",
					speed = speed,
					marcha = carGear,
					gear = vehicleGear,
					fuel = parseInt(fuel),
					engine = math.ceil((engine / 1000) * 100),
					rpmnail = vehicleNailRpm,
					rpm = rpm/100,
					cinto = CintoSeguranca,
					hudoff = hudoff,
					seatbelt = beltLock,
					farol = farol,
				})
			end		
		end
		Citizen.Wait(hyper)	
	end
end)

Citizen.CreateThread(function()
	while true do
		local hyper = 1000
		if not inCar then 
			local ped = PlayerPedId()
			DisplayRadar(false)

			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			local armour = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())

			SendNUIMessage({
				action = "update",
				health = vida,
				armour = armour,
				stamina = stamina,
				street = street,
				hudoff = hudoff,
				hunger = parseInt(hunger),
				thirst = parseInt(thirst),
			})			

		end
		Citizen.Wait(hyper)	
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOWARDPED
-----------------------------------------------------------------------------------------------------------------------------------------
function fowardPed(ped)
	local heading = GetEntityHeading(ped) + 90.0
	if heading < 0.0 then
		heading = 360.0 + heading
	end

	heading = heading * 0.0174533

	return { x = math.cos(heading) * 2.0, y = math.sin(heading) * 2.0 }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("seatbelt",function(source,args)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		if not IsPedOnAnyBike(ped) then
			if beltLock == 1 then
				TriggerEvent("quantum_sound:source","unbelt",0.5)
				beltLock = 0
				CintoSeguranca2 = false
			else
				TriggerEvent("quantum_sound:source","belt",0.5)
				beltLock = 1
				CintoSeguranca2 = true

			end
		end
	end
end)

RegisterCommand('+indicatorlights',function(source,args)
	local ped = PlayerPedId()
	local isIn = IsPedInAnyVehicle(ped,false)
	if isIn then
	local vehicle = GetVehiclePedIsIn(ped, false)
	local lights = GetVehicleIndicatorLights(vehicle)
			if args[1] == 'up' then
				lightState = 'up'
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,true)
			elseif args[1] == 'left' then
				lightState = 'left'
				SetVehicleIndicatorLights(vehicle,1,true)
				SetVehicleIndicatorLights(vehicle,0,false)
			elseif args[1] == 'right' then
				lightState = 'right'
				SetVehicleIndicatorLights(vehicle,0,true)
				SetVehicleIndicatorLights(vehicle,1,false)
			elseif args[1] == 'off' and lights >= 0 then
				lightState = 'off'
				SetVehicleIndicatorLights(vehicle,0,false)
				SetVehicleIndicatorLights(vehicle,1,false)
			end
	end
end)

RegisterKeyMapping("+indicatorlights up","Ambas setas.","keyboard","UP")
RegisterKeyMapping("+indicatorlights left","Seta para esquerda.","keyboard","LEFT")
RegisterKeyMapping("+indicatorlights right","Seta para direita.","keyboard","RIGHT")
RegisterKeyMapping("+indicatorlights off","Desligar setas.","keyboard","BACK")

-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("seatbelt","Colocar/Retirar o cinto.","keyboard","g")

RegisterCommand("hud",function(source,args)
	hudoff = not hudoff
end)

RegisterNetEvent("tksInterface:off")
AddEventHandler("tksInterface:off", function()
	hudoff = not hudoff
	SendNUIMessage({hudoff = hudoff})
end)

RegisterNetEvent("tksInterface:on")
AddEventHandler("tksInterface:on", function()
	hudoff = false
	SendNUIMessage({hudoff = hudoff})
end)
-------------------------------------------
RegisterCommand('seat', function(source, args, rawCmd)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then	
		local carrinhu = GetVehiclePedIsIn(ped, false)
		if not seatbeltIsOn then
			if args[1] then
				local acento = parseInt(args[1])
				
				if acento == 1 then
					if IsVehicleSeatFree(carrinhu, -1) then 
						if GetPedInVehicleSeat(carrinhu, 0) == ped then
							SetPedIntoVehicle(ped, carrinhu, -1)
						else
							TriggerEvent('Notify', 'negado','Você só pode passar para o P1 a partir do P2.')
						end
					else
						TriggerEvent('Notify','negado','O acento deve estar livre.')
					end
				elseif acento == 2 then
					if IsVehicleSeatFree(carrinhu, 0) then 
						if GetPedInVehicleSeat(carrinhu, -1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 0)
						else
							TriggerEvent('Notify', 'negado','Você só pode passar para o P2 a partir do P1.')
						end
					else
						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
					end
				elseif acento == 3 then
					if IsVehicleSeatFree(carrinhu, 1) then 
						if GetPedInVehicleSeat(carrinhu, 2) == ped then
							SetPedIntoVehicle(ped, carrinhu, 1)
						else
							TriggerEvent('Notify', 'negado','Você só pode passar para o P3 a partir do P4.')
						end
					else
						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
					end
				elseif acento == 4 then
					if IsVehicleSeatFree(carrinhu, 2) then 
						if GetPedInVehicleSeat(carrinhu, 1) == ped then
							SetPedIntoVehicle(ped, carrinhu, 2)
						else
							TriggerEvent('Notify', 'negado','Você só pode passar para o P4 a partir do P3.')
						end
					else
						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
					end
				end
			else
				TriggerEvent('Notify', 'negado','Especifique o acento que quer ir!')
			end
		else
			TriggerEvent('Notify', 'negado','Você não pode utilizar esse comando com o cinto de segurança!')
		end
	end
end)
-------------------------------------------
-- NÃO PASSAR PARA O P1 
---------------------------------------------------------
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
                if GetIsTaskActive(GetPlayerPed(-1), 165) then
                    SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                end
            end
        end
    end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        disableSeatShuffle(false)
        Citizen.Wait(5000)
        disableSeatShuffle(true)
    else
        CancelEvent()
    end
end)


----------------------
RegisterCommand("cr",function(source,args)
	local veh = GetVehiclePedIsIn(PlayerPedId(),false)
	local maxspeed = GetVehicleMaxSpeed(GetEntityModel(veh))
	local vehspeed = GetEntitySpeed(veh)*3.605936
	if GetPedInVehicleSeat(veh,-1) == PlayerPedId() and math.ceil(vehspeed) >= 0 and GetEntityModel(veh) ~= -2076478498 and not IsEntityInAir(veh) then
		if args[1] == nil then
			SetEntityMaxSpeed(veh,maxspeed)
			TriggerEvent("Notify","sucesso","Limitador de Velocidade desligado com sucesso.")
		else
			SetEntityMaxSpeed(veh,0.45*args[1]-0.45)
			TriggerEvent("Notify","sucesso","Velocidade máxima travada em <b>"..args[1].." KM/H</b>.")
		end
	end
end)

RegisterNetEvent("hud:talknow")
AddEventHandler("hud:talknow", function(boolean)
    SendNUIMessage({action = "talking", boolean = boolean})
end)

RegisterNetEvent("hud:channel")
AddEventHandler("hud:channel", function(text)
    SendNUIMessage({action = "channel", radio = text})
end)

RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode", function(number) 
    SendNUIMessage({action = "proximity", voice = number})
end)

local StatusCarro = true
Citizen.CreateThread(function()
    while true do
		local hyper = 1000
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
			hyper = 1000
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            if (lockStatus == 1) then
				StatusCarro = true
                SendNUIMessage({
					lock = "fecharcarro", 
					status = StatusCarro,
				})
            elseif lockstatus ~= 1 then
				StatusCarro = false
                SendNUIMessage({
					lock = "fecharcarro", 
					status = StatusCarro,
				})
            end
        end
		Citizen.Wait(hyper)	
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        local newhealth = health - 1

        if thirst >= 95 then
            alertmaxfome = true
            SetEntityHealth(ped, newhealth)
        end
        if hunger >= 95 then 
            alertmaxsede = true
            SetEntityHealth(ped, newhealth)
        end
            
        if hunger <= 95 and thirst <= 95 and GetEntityHealth(PlayerPedId()) >= 102 then
            alertmaxsede = false
            alertmaxfome = false
        end

    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setWay",function(data)
    SetNewWaypoint(data.x+0.0001,data.y+0.0001)
end)

function updateMapPosition()

    local minimapXOffset,minimapYOffset = 0,0
    
    DisplayRadar(false)
    
    RequestStreamedTextureDict("circleminimap",false)
    while not HasStreamedTextureDictLoaded("circleminimap") do
        Wait(100)
    end
    
    SetMinimapClipType(1)
    AddReplaceTexture("platform:/textures/graphics","radarmasksm","circleminimap","radarmasksm")
    SetMinimapComponentPosition("minimap", "L", "B", -0.0045+minimapXOffset, 0.002+minimapYOffset-0.025, 0.150, 0.188888)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020+minimapXOffset, 0.030+minimapYOffset-0.025, 0.111, 0.159)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03+minimapXOffset, 0.022+minimapYOffset-0.040, 0.266, 0.200)
    
    SetBigmapActive(true,false)
    Wait(50)
    SetBigmapActive(false,false)
end

CreateThread(function()
    updateMapPosition()
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESSBAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("progress")
AddEventHandler("progress",function(timer, name)
	SendNUIMessage({ action = 'setProgress', progress = true, value = parseInt(timer) })
end)