local noclip = false

function quantum.toggleNoclip()
	noclip = not noclip
	local ped = PlayerPedId()
	if noclip then
		SetEntityInvincible(ped,false) --mqcu
		SetEntityVisible(ped,false,false)
		Citizen.CreateThread(function()
			while noclip do
				Citizen.Wait(1)	
				local ped = PlayerPedId()
				local pCDS = GetEntityCoords(ped)
				local x,y,z = pCDS.x,pCDS.y,pCDS.z
				local dx,dy,dz = quantum.getCamDirection()
				local speed = 0.8
	
				SetEntityVelocity(ped,0.0001,0.0001,0.0001)
	
				if IsControlPressed(0,21) then
					speed = 4.0
				end
	
				if IsControlPressed(0,32) then
					x = x+speed*dx
					y = y+speed*dy
					z = z+speed*dz
				end
	
				if IsControlPressed(0,269) then
					x = x-speed*dx
					y = y-speed*dy
					z = z-speed*dz	
				end
				SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
			end
		end)
	else
		SetEntityInvincible(ped,false)
		SetEntityVisible(ped,true,false)
	end
end

function quantum.isNoclip()
	return noclip
end

function quantum.setHandcuffed(bool)
	local ply = PlayerPedId()
	if (bool) then
		LocalPlayer.state.Handcuff = true
		SetEnableHandcuffs(ply, true)
	else
		LocalPlayer.state.Handcuff = false
		SetEnableHandcuffs(ply, false)
	end
end
exports('setHandcuffed', quantum.setHandcuffed)

function quantum.isHandcuffed()
	return LocalPlayer.state.Handcuff
end
exports('isHandcuffed', quantum.isHandcuffed)

function quantum.setFreeze(bool)
	FreezeEntityPosition(PlayerPedId(),bool)
end

function quantum.setCapuz(bool)
	local ply = PlayerPedId()
	if (bool) then
		exports.quantum_system:SendNuiMessage('capuz', true)
		TriggerEvent('quantum_hud:toggleHud', false)
		TriggerEvent('tksInterface:off')
		LocalPlayer.state.Capuz = true
		SetPedComponentVariation(ply, 1, 69, 1, 2)
	else
		exports.quantum_system:SendNuiMessage('capuz', false)
		TriggerEvent('quantum_hud:toggleHud', true)
		TriggerEvent('tksInterface:on')
		LocalPlayer.state.Capuz = false
		SetPedComponentVariation(ply, 1, 0, 0, 2)
	end
end
exports('setCapuz', quantum.setCapuz)

function quantum.isCapuz()
	return LocalPlayer.state.Capuz
end
exports('isCapuz', quantum.isCapuz)

local mala = false
function quantum.toggleMalas()
	mala = not mala
	ped = PlayerPedId()
	vehicle = quantum.getNearestVehicle(7)

	if IsEntityAVehicle(vehicle) then
		if mala then
			AttachEntityToEntity(ped,vehicle,GetEntityBoneIndexByName(vehicle,"bumper_r"),0.6,-0.4,-0.1,60.0,-90.0,180.0,false,false,false,true,2,true)
			SetEntityVisible(ped,false)
			SetEntityInvincible(ped,false) -- MQCU
		else
			DetachEntity(ped,true,true)
			SetEntityVisible(ped,true)
			SetEntityInvincible(ped,false)
			SetPedToRagdoll(ped,2000,2000,0,0,0,0)
		end
		TriggerServerEvent("trymala",VehToNet(vehicle))
	end
end

RegisterNetEvent("syncmala")
AddEventHandler("syncmala",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDoorOpen(v,5,0,0)
				Citizen.Wait(1000)
				SetVehicleDoorShut(v,5,0)
			end
		end
	end
end)

function quantum.setMalas(flag)
	if mala ~= flag then
		quantum.toggleMalas()
	end
end

function quantum.isMalas()
	return mala
end

function quantum.getNoCarro()
	return IsPedInAnyVehicle(PlayerPedId())
end

function quantum.getCarroClass(vehicle)
	return GetVehicleClass(vehicle) == 0 or GetVehicleClass(vehicle) == 1 or GetVehicleClass(vehicle) == 2 or GetVehicleClass(vehicle) == 3 or GetVehicleClass(vehicle) == 4 or GetVehicleClass(vehicle) == 5 or GetVehicleClass(vehicle) == 6 or GetVehicleClass(vehicle) == 7 or GetVehicleClass(vehicle) == 9 or GetVehicleClass(vehicle) == 12
end

function quantum.putInNearestVehicleAsPassenger(radius)
	local veh = quantum.getNearestVehicle(radius)
	if IsEntityAVehicle(veh) then
		for i = 0, GetVehicleMaxNumberOfPassengers(veh) do
			if IsVehicleSeatFree(veh,i) then
				TaskEnterVehicle(PlayerPedId(), veh, -1, i, 1.5, 1, 0)
				return true
			end
		end
	end
	return false
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		local timing = 1000
-- 		if handcuffed or mala or capuz then
-- 			timing = 5
-- 			BlockWeaponWheelThisFrame()
-- 			DisableControlAction(0,20,true)
-- 			DisableControlAction(0,21,true)
-- 			DisableControlAction(0,22,true)
-- 			DisableControlAction(0,23,true)
-- 			DisableControlAction(0,24,true)
-- 			DisableControlAction(0,25,true)
-- 			DisableControlAction(0,29,true)
-- 			DisableControlAction(0,32,true)
-- 			DisableControlAction(0,33,true)
-- 			DisableControlAction(0,34,true)
-- 			DisableControlAction(0,35,true)
-- 			DisableControlAction(0,56,true)
-- 			DisableControlAction(0,57,true)
-- 			DisableControlAction(0,58,true)
-- 			DisableControlAction(0,73,true)
-- 			DisableControlAction(0,75,true)
-- 			DisableControlAction(0,137,true)
-- 			DisableControlAction(0,140,true)
-- 			DisableControlAction(0,141,true)
-- 			DisableControlAction(0,142,true)
-- 			DisableControlAction(0,143,true)
-- 			DisableControlAction(0,166,true)
-- 			DisableControlAction(0,167,true)
-- 			DisableControlAction(0,170,true)
-- 			DisableControlAction(0,177,true)
-- 			DisableControlAction(0,178,true)
-- 			DisableControlAction(0,182,true)
-- 			DisableControlAction(0,187,true)
-- 			DisableControlAction(0,188,true)
-- 			DisableControlAction(0,189,true)
-- 			DisableControlAction(0,190,true)
-- 			DisableControlAction(0,243,true)
-- 			--DisableControlAction(0,245,true)
-- 			--DisableControlAction(0,246,true)
-- 			DisableControlAction(0,257,true)
-- 			DisableControlAction(0,263,true)
-- 			DisableControlAction(0,264,true)
-- 			DisableControlAction(0,268,true)
-- 			DisableControlAction(0,269,true)
-- 			DisableControlAction(0,270,true)
-- 			DisableControlAction(0,271,true)
-- 			DisableControlAction(0,288,true)
-- 			DisableControlAction(0,289,true)
-- 			--DisableControlAction(0,303,true)
-- 			DisableControlAction(0,311,true)
-- 			DisableControlAction(0,344,true)	
-- 		end
-- 		Citizen.Wait(timing)
-- 	end
-- end)