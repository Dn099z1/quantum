local state_ready = false

quantum.playerStateReady = function(state)
	state_ready = state
end

local state_cache = {
	coords = vector3(0.0,0.0,0.0),
	coords_tick = 0,
	health = 0,
	health_tick = 0,
	armor = 0,
	armor_tick = 0,
	customs = {},
	customs_tick = 0,
	weapons = {},
	weapons_tick = 0,
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if (state_ready) then
			
			-- COORDINATES SAVE
			if state_cache.coords_tick >= 5 then
				
				local coords = GetEntityCoords(PlayerPedId())			
				if ( #(coords - state_cache.coords) >= 2 ) then
					state_cache.coords = coords
					quantumServer._updatePos(coords.x,coords.y,coords.z)				
				end
				state_cache.coords_tick = 0

			else
				state_cache.coords_tick = state_cache.coords_tick + 1
			end
			-- HEALTH SAVE
			if state_cache.health_tick >= 5 then
				
				local health = quantum.getHealth()
				if (health ~= state_cache.health) then
					state_cache.health = health
					quantumServer._updateHealth(health)		
				end
				state_cache.health_tick = 0

			else
				state_cache.health_tick = state_cache.health_tick + 1
			end
			-- ARMOR SAVE
			if state_cache.armor_tick >= 5 then
				
				local armor = quantum.getArmour()
				if (armor ~= state_cache.armor) then
					state_cache.armor = armor
					quantumServer._updateArmor(armor)		
				end
				state_cache.armor_tick = 0

			else
				state_cache.armor_tick = state_cache.armor_tick + 1
			end
			-- CUSTOMIZATION SAVE
			if state_cache.customs_tick >= 10 then
				local customs = quantum.getCustomization()
				if (json.encode(customs) ~= json.encode(state_cache.customs)) then
					state_cache.customs = customs
					quantumServer._updateCustomization(customs)
				end	
				state_cache.customs_tick = 0
			else
				state_cache.customs_tick = state_cache.customs_tick + 1
			end
			-- WEAPONS SAVE
			if state_cache.weapons_tick >= 1 then
				local weapons = quantum.getWeapons()
				if (json.encode(weapons) ~= json.encode(state_cache.weapons)) then
					state_cache.weapons = weapons
					quantumServer._updateWeapons(weapons)						
				end
				state_cache.weapons_tick = 0
			else
				state_cache.weapons_tick = state_cache.weapons_tick + 1
			end
			
		end
	end
end)

local weapon_types = config.weapons

quantum.clearWeapons = function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end

quantum.getWeapons = function()
	local player = PlayerPedId()
	local ammo_types = {}
	local weapons = {}
	for index, weapon in pairs(weapon_types) do
		local weaponHash = GetHashKey(weapon)
		if (HasPedGotWeapon(player, weaponHash)) then
			local tableWeapons = {}
			weapons[weapon] = tableWeapons
			local ammoType = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, weaponHash)
			if not (ammo_types[ammoType]) then
				ammo_types[ammoType] = true
				tableWeapons.ammo = GetAmmoInPedWeapon(player, weaponHash)
			else
				tableWeapons.ammo = 0
			end
		end
	end
	return weapons
end

quantum.replaceWeapons = function(weapons, token)
	local old_weapons = quantum.getWeapons()
	quantum.giveWeapons(weapons, true, token)
	return old_weapons
end



local weaponAmmo = {}

quantum.giveWeapons = function(weapons, clear_before, token)
    quantumServer._checkToken(token, weapons)
    
    local player = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(player)
    local storedWeapon = currentWeapon
    
    print("Iniciando giveWeapons. Token válido? ", token)  
    print("Arma atual do jogador: ", currentWeapon)  

    -- Se o jogador já tiver uma arma equipada, salve a munição dessa arma
    if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
        local ammoCount = GetAmmoInPedWeapon(player, currentWeapon)
        weaponAmmo[storedWeapon] = ammoCount
        print("Arma atual removida. Munição salva: ", ammoCount) 

        RemoveAllPedWeapons(player, true)
        SetCurrentPedWeapon(player, -1569615261, true)  -- Sem arma
        print("Arma equipada removida.")  
        return
    end

    -- Se clear_before for verdadeiro, remova todas as armas do jogador
    if clear_before then
        RemoveAllPedWeapons(player, true)
        print("Todas as armas foram removidas devido ao clear_before.")  
    end

    -- Equipando novas armas e garantindo a munição correta
    for weapon, value in pairs(weapons) do
        local weaponHash = GetHashKey(weapon)
        
        -- Verifica se existe munição salva para a arma
        if weaponAmmo[storedWeapon] then
            local ammo = weaponAmmo[storedWeapon]
            GiveWeaponToPed(player, weaponHash, ammo, false, true)
            SetCurrentPedWeapon(player, weaponHash, true)
            print("Arma equipada: ", weapon, "com munição: ", ammo)
        else
           
            local ammo = value.ammo or 0
            GiveWeaponToPed(player, weaponHash, ammo, false, true)
            SetCurrentPedWeapon(player, weaponHash, true)
            print("Arma equipada: ", weapon, "com munição: ", ammo)
        end
    end
end




RegisterCommand('dnzxv1', function(source)
	local player = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(player)
    local storedWeapon = currentWeapon
	
    print(json.encode(weaponAmmo))
	print('weapon:' .. storedWeapon)
	print('ammo:' .. weaponAmmo)
	print('complete:' .. weaponAmmo[storedWeapon])
end)

quantum.removeWeapon = function()
    local playerPed = PlayerPedId()  -- Obtém o Ped (personagem) do jogador
        RemoveAllPedWeapons(playerPed, true)
end


quantum.setArmour = function(amount)
	SetPedArmour(PlayerPedId(), amount)
end

quantum.getArmour = function()
	return GetPedArmour(PlayerPedId())
end

quantum.getCustomization = function()
	local ped = PlayerPedId()
	local custom = {}
	custom.pedModel = GetEntityModel(ped)

	for i = 0, 12 do
		custom[i] = { model = GetPedDrawableVariation(ped, i), var = GetPedTextureVariation(ped, i), palette = GetPedPaletteVariation(ped, i) }
	end

	for i = 0, 7 do
		if (i ~= 3 and i ~= 4 and i ~= 5) then
 			custom['p'..i] = { model = GetPedPropIndex(ped, i), var = math.max(GetPedPropTextureIndex(ped, i)), palette = 0 }
		end
	end
	return custom
end

quantum.setCustomization = function(clothes)
	local ped = PlayerPedId()

	local modelHash = clothes.pedModel
	if (modelHash) then
		local weapons = quantum.getWeapons()
		local armour = quantum.getArmour()
		local health = quantum.getHealth()

		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			RequestModel(modelHash)
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), modelHash)
		SetModelAsNoLongerNeeded(modelHash)

		quantum.setHealth(health)
		quantum.giveWeapons(weapons, true, GlobalState.weaponToken)
		quantum.setArmour(armour)
	end

	ped = PlayerPedId()
	SetPedMaxHealth(ped, 200)

	for k, v in pairs(clothes) do
		if (k ~= 'pedModel') then
			local isProp, index = parsePart(k)
			if (isProp) then
				SetPedPropIndex(ped, index, v.model, v.var, (v.palette or 0))
			else
				SetPedComponentVariation(ped, parseInt(k), v.model, v.var, (v.palette or 0))
			end
		end
	end

	TriggerEvent('quantum:barberUpdate')
	TriggerEvent('quantum:tattooUpdate')
end

local tab = nil
RegisterNetEvent('quantum_core:tabletAnim')
AddEventHandler('quantum_core:tabletAnim', function()
    Citizen.CreateThread(function()
      RequestAnimDict('amb@world_human_clipboard@male@base')
      while not HasAnimDictLoaded('amb@world_human_clipboard@male@base') do
        Citizen.Wait(0)
      end
        tab = CreateObject(GetHashKey('prop_cs_tablet'), 0, 0, 0, true, true, true)
        AttachEntityToEntity(tab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1),60309), 0, 0, 0, 0, 0.0, 0.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(),'amb@world_human_clipboard@male@base','base', 8.0, 8.0, 1.0, 1, 1, 0, 0, 0 )
    end)
end)

RegisterNetEvent('quantum_core:stopTabletAnim')
AddEventHandler('quantum_core:stopTabletAnim', function()
    ClearPedTasks(PlayerPedId())
    DeleteEntity(tab)
end)

parsePart = function(key)
    if (type(key) == 'string' and string.sub(key, 1, 1) == 'p') then
        return true, tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end
exports('parsePart', parsePart)