AddEventHandler('quantum:playerSpawn', function(user_id, source, firstSpawn)
	local data = quantum.getUserDataTable(user_id)
	
	-- [ Teleport ] --
	if (data.position) then
		quantumClient.teleport(source, data.position.x, data.position.y, data.position.z)
	end

	exports.quantum_appearance:setCustomization(source, user_id)

	-- [ Health ] --
	if (data.health == nil) then
		data.health = 400
	end
	quantumClient.setHealth(source, data.health)
	Citizen.SetTimeout(5000, function()
		if (quantumClient.isInComa(source)) then
			quantumClient.killComa(source)
		end
	end)
	----------------------------------

	-- [ Armour ] --
	if (data.armour == nil) then
		data.armour = 0
	end
	Citizen.SetTimeout(10000, function()
		quantumClient.setArmour(source, data.armour)
	end)
	----------------------------------

	-- [ Weapons ] --
	if (data.weapons == nil) then
		data.weapons = {}
	end
	--quantumClient.giveWeapons(source, data.weapons, true, GlobalState.weaponToken)
	----------------------------------

	-- [ Fome ] --
	if (data.hunger == nil) then
		data.hunger = 0
	end

	if (data.thirst == nil) then
		data.thirst = 0
	end
	----------------------------------

	quantumClient.setFriendlyFire(source, true)
	quantumClient.playerStateReady(source, true)
end)

quantum.updatePos = function(x, y, z)
	local user_id = quantum.getUserId(source)
	if user_id then
		local data = quantum.getUserDataTable(user_id)
		if (data) then 
			data.position = { x = tonumber(x), y = tonumber(y), z = tonumber(z) } 
		end
	end
end

quantum.updateArmor = function(armor)
	local user_id = quantum.getUserId(source)
	if user_id then
		local data = quantum.getUserDataTable(user_id)
		if (data) then 
			data.armour = armor 
		end
	end
end

quantum.updateWeapons = function(weapons)
	local user_id = quantum.getUserId(source)
	if user_id then
		local data = quantum.getUserDataTable(user_id)
		if (data) then 
			data.weapons = weapons 
		end
	end
end

quantum.updateCustomization = function(customization)
	local user_id = quantum.getUserId(source)
	if user_id then
		quantum.execute('quantum_appearance/saveClothes', { user_id = user_id, user_clothes = json.encode(customization) } )
	end
end

quantum.updateHealth = function(health)
	local user_id = quantum.getUserId(source)
	if user_id then
		local data = quantum.getUserDataTable(user_id)
		if (data) then 
			data.health = health 
		end
	end
end

quantum.clearAfterDie = function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
		quantum.RemoveAferDie(user_id, 0)
		quantum.varyThirst(user_id, -100)
		quantum.varyHunger(user_id, -100)

		quantumClient._clearWeapons(source)
		quantumClient._setHandcuffed(source, false)

		quantum.clearInventory(user_id)

		Player(source).state.Capuz = false
		quantumClient.setCapuz(source, false)

		Player(source).state.Handcuff = false
        quantumClient.setHandcuffed(source, false)
		TriggerClientEvent('quantum_interactions:algemas', source)
		return true
    end
	return false
end

local timersCooldown = {}

quantum.getUserTimer = function(user_id, timerType)
	if (user_id and timerType) then
		if timersCooldown[user_id] then
			return timersCooldown[user_id][timerType]
		end
	end
	return false
end

quantum.setUserTimer = function(user_id, timerType, seconds)
	if (user_id and timerType and seconds) then
		if not (timersCooldown[user_id]) then
			timersCooldown[user_id] = {}	
		end
		
		if not (timersCooldown[user_id][timerType]) then
			threadTimer(user_id, timerType, seconds)
		else
			local oldSecs = timersCooldown[user_id][timerType]
			if (oldSecs) then
				timersCooldown[user_id][timerType] = oldSecs + parseInt(seconds)
			end
		end
	end
end

threadTimer = function(user_id, timerType, time)
	Citizen.CreateThread(function()
		timersCooldown[user_id][timerType] = time
		while (timersCooldown[user_id][timerType] > 0) do
			Citizen.Wait(1000)
			timersCooldown[user_id][timerType] = timersCooldown[user_id][timerType] - 1
		end
		timersCooldown[user_id][timerType] = nil
	end)
end

RegisterCommand('procurado', function(source)
	local user_id = quantum.getUserId(source)
	if user_id then
		if (quantum.getUserTimer(user_id, 'wanted')) then
			TriggerClientEvent('Notify', source, 'sucesso', 'Você está sendo <b>procurado</b>! Tempo: <b>'..quantum.getUserTimer(user_id, 'wanted')..' segundos</b>.')
		else
			TriggerClientEvent('Notify', source, 'negado', 'Você não está sendo <b>procurado</b>!')
		end
	end
end)

GlobalState.weaponToken = 404
Citizen.SetTimeout(2000,function()
	math.randomseed(GetGameTimer())
	GlobalState.weaponToken = math.random(50000,70000)
end)

quantum.checkToken = function(tokenSend, weapons)
	local source = source
	if (GlobalState.weaponToken ~= tokenSend) then
		local user_id = quantum.getUserId(source)
		local identifiers = quantum.getIdentifiers(source)

		DropPlayer(source, 'New Valley - ANTI CHEAT')
		exports['quantum_core']:setBanned(user_id, true)
		exports.quantum_core:insertBanRecord(user_id, true, -1, '[TOKEN] spawn de armas!')
		quantum.webhook('WeaponToken', '```prolog\n[PLAYER]: '..tostring(user_id)..'\n[TOKEN-ENVIADO]: '..tostring(tokenSend)..'\n[TOKEN-SISTEMA]: '..tostring(GlobalState.weaponToken)..'\n[ARMAS]:\n'..json.encode(weapons,{ indent = true })..'\n[IDENTIFIERS]:\n'..json.encode(ids,{ indent = true })..'```')	
	end
end

RegisterCommand('reloadtoken',function(source,args)
	if (source == 0) then
		GlobalState.weaponToken = math.random(50000,70000)
		print("^2[vRP] ^8[WARNING!] ^2Weapons Token Regenerated! <"..GlobalState.weaponToken..">^7")
	end
end)

RegisterNetEvent('trymala', function(nveh)
	TriggerClientEvent('syncmala', -1, nveh)
end)