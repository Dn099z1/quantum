cacheUsers = {}
cacheUsers.users = {}
cacheUsers.rusers = {}
cacheUsers.user_source = {}
cacheUsers.user_tables = {}
cacheUsers.firstSpawn = {}

local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false

quantum.registerDBDriver = function(name, on_init, on_prepare, on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init, on_prepare, on_query }
		if name == 'oxmysql' then
			db_driver = db_drivers[name]
			local ok = on_init('oxmysql')
			if ok then
				db_initialized = true
				for _,prepare in pairs(cached_prepares) do
					on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
				end
				for _,query in pairs(cached_queries) do
					query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
				end
				cached_prepares = nil
				cached_queries = nil
			end
		end
	end
end
vRP.registerDBDriver = quantum.registerDBDriver

quantum.prepare = function(name, query)
	prepared_queries[name] = true
	if db_initialized then
		db_driver[2](name,query)
	else
		table.insert(cached_prepares,{ name,query })
	end
end
vRP.prepare = quantum.prepare

quantum.query = function(name, params, mode)
	if not mode then mode = "query" end
	if db_initialized then
		return db_driver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cached_queries,{{ name,params or {},mode },r })
		return r:wait()
	end
end
vRP.query = quantum.query

quantum.insertPlate = function(plate)
	print('chegou:' .. plate)
TriggerClientEvent('quantum_garage:lockpickUsage',plate)
end

quantum.execute = function(name, params)
	return quantum.query(name, params, "execute")
end
vRP.execute = quantum.execute

quantum.insert = function(name, params)
	return quantum.query(name, params, "insert")
end
vRP.insert = quantum.insert

quantum.scalar = function(name, params)
	return quantum.query(name, params, "scalar")
end
vRP.scalar = quantum.scalar

quantum.format = function(n)
	local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
vRP.format = quantum.format

quantum.isBanned = function(user_id)
	return exports['quantum_core']:isBanned(user_id)
end
vRP.isBanned = quantum.isBanned

quantum.setBanned = function(user_id, banned)
	return exports['quantum_core']:setBanned(user_id, banned)
end
vRP.setBanned = quantum.setBanned

quantum.getIdentifiers = function(source)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(source)-1 do
        local id = GetPlayerIdentifier(source, i)
        
		local prefix = splitString(id,":")[1]
		identifiers[prefix] = id
    end
    return identifiers
end
vRP.getIdentifiers = quantum.getIdentifiers

quantum.getUData = function(user_id, key)
	local rows = quantum.query("quantum/get_userdata", { user_id = user_id, key = key })
	if #rows > 0 then
		return rows[1].dvalue
	end
	return ""
end
vRP.getUData = quantum.getUData

quantum.setUData = function(user_id, key, value)
	quantum.execute("quantum/set_userdata", { user_id = user_id, key = key, value = value })
end
vRP.setUData = quantum.setUData

quantum.getSData = function(key)
	local rows = quantum.query("quantum/get_srvdata", { key = key })
	if #rows > 0 then
		return rows[1].dvalue
	end
	return ""
end
vRP.getSData = quantum.getSData

quantum.setSData = function(key, value)
	quantum.execute("quantum/set_srvdata",{ key = key, value = value })
end
vRP.setSData = quantum.setSData

quantum.remSData = function(dkey)
	quantum.execute("quantum/rem_srv_data",{ dkey = dkey })
end
vRP.remSData = quantum.remSData

quantum.getUsers = function()
	local users = {}
	for k, v in pairs(cacheUsers.user_source) do
		users[k] = v
	end
	return users
end
vRP.getUsers = quantum.getUsers

quantum.getUserDataTable = function(user_id)
	return cacheUsers.user_tables[user_id]
end
vRP.getUserDataTable = quantum.getUserDataTable

quantum.setKeyDataTable = function(user_id, key, value)
	if (cacheUsers.user_tables[user_id]) then
		cacheUsers.user_tables[user_id][key] = value
	end
end
vRP.setKeyDataTable = quantum.setKeyDataTable

quantum.getUserId = function(source)
	if (source ~= nil) then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return cacheUsers.users[ids[1]]
		end
	end
	return nil
end
vRP.getUserId = quantum.getUserId

quantum.getUserSource = function(user_id)
	return cacheUsers.user_source[user_id]
end
vRP.getUserSource = quantum.getUserSource

concatInv = function(TableInv)
	local txt = ''
	if TableInv and type(TableInv) == 'table' then
		for k, v in pairs(TableInv) do
			if k ~= nil and v ~= nil then
				txt = '\n   ' .. quantum.format(v.amount or 0) .. 'x ' .. (quantum.itemNameList(k) or k) .. txt
			end
		end
		if txt == '' then
			return 'MOCHILA VAZIA'
		else 
			return txt
		end
	end
	return 'ERRO AO ENCONTRAR INVENTARIO'
end

concatArmas = function(TableInv)
	local txt = ''
	if TableInv and type(TableInv) == 'table' then
		for k, v in pairs(TableInv) do
			txt = '\n   ' .. (quantum.itemNameList(k) or k) .. ' [' .. tostring(v.ammo) .. ']' .. txt
		end
		if txt == '' then
			return 'DESARMADO'
		else
			return txt
		end
	end
	return 'ERRO AO ENCONTRAR ARMAS'
end

quantum.kick = function(source, reason)
	DropPlayer(source, reason)
end
vRP.kick = quantum.kick

quantum.getUserIdByIdentifiers = function(ids)
	if (#ids > 0) then
		for i = 1, #ids do
			local _ids = ids[i]
			if (string.find(_ids, 'ip:') == nil) then
				local rows = quantum.query('quantum_framework/getIdentifier', { identifier = _ids })
				if (#rows > 0) then return rows[1].user_id; end;
			end
		end

		local newUserId = quantum.insert('quantum_framework/createUser')
		if (newUserId > 0) then
			for i = 1, #ids do
				local _ids = ids[i]
				if (string.find(_ids, 'ip:') == nil) then
					quantum.execute('quantum_framework/addIdentifier', { user_id = newUserId, identifier = _ids })
				end
			end
			return newUserId
		end
	end
	return false
end
vRP.getUserIdByIdentifiers = quantum.getUserIdByIdentifiers

formatIdentifiers = function(source)
	local _identifiers = quantum.getIdentifiers(source)
	
	local steamURL, steamID = '', ''
	steamID = '\n**[STEAM HEX]** - '..(_identifiers.steam or 'OFFLINE')
	if (_identifiers.steam) then
		steamURL = '\n**[STEAM URL]** - https://steamcommunity.com/profiles/'..tonumber(_identifiers.steam:gsub('steam:', ''), 16)
	end

	local discord;
	discord = '\n**[DISCORD]** - NÃO ENCONTRADO'
	if (_identifiers.discord) then
		discord = '\n**[DISCORD]** - <@'.._identifiers.discord:gsub('discord:', '')..'>'
	end
	return steamURL, steamID, discord
end

local BypassMaintenance = function(user_id)
	for group, _ in pairs(quantum.getUserGroups(user_id)) do
		if (config.maintenanceGroups[group]) then
			return true
		end
	end
	return false
end

AddEventHandler('queue:playerConnecting', function(source, ids, name, _, deferrals)
	if not (name) then name = 'user'; end;

	deferrals.defer()
	deferrals.update('Olá '..name..', estamos carregando as identidades do servidor...')
	
	local source = source
	if (#ids < 1) then ids = GetPlayerIdentifiers(source); end;
		
	local user_id = quantum.getUserIdByIdentifiers(ids)
	if (not user_id) then
		deferrals.done('Olá '..name..', ocorreu um problema de identificação, tente logar novamente.')
		TriggerEvent('queue:playerConnectingRemoveQueues', ids)
		return
	end

	if (cacheUsers.user_source[user_id] ~= nil) then
		if (GetPlayerName(cacheUsers.user_source[user_id]) ~= nil) then
			deferrals.done('Olá '..name..', verificamos que o seu passaporte se encontra com problemas, tente logar novamente.')
			TriggerEvent('queue:playerConnectingRemoveQueues', ids)
			DropPlayer(cacheUsers.user_source[user_id], 'New Valley: Você foi expulso, tente logar novamente!')
			return
		end
	end
		
	deferrals.update('Olá '..name..', estamos carregando os banimentos do servidor...')
	if (quantum.isBanned(user_id)) then
		local reason, date, staff = exports.quantum_core:getBanRecord(user_id)
		if (staff) then local staffIdentity = quantum.getUserIdentity(parseInt(staff)) end;

		local text = (staffIdentity and staff..'# '..staffIdentity.firstname..' '..staffIdentity.lastname or 'Sistema da New Valley')
		deferrals.done('\nOlá '..name..', infelizmente você foi banido de nossa cidade!\n\nMotivo: '..reason..'\nPunição aplicada por: '..text..'\nData do ocorrido: '..os.date('%d/%m/%Y - %H:%M', math.floor(date/1000))..'\n\nVocê achou o seu banimento injusto? abra um ticket em nosso discord: https://discord.gg/newvalleyrp ')
		TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		return
	end

	if (config.maintenanceMode) then
		if (not BypassMaintenance(user_id)) then
			deferrals.done('Olá '..name..', a cidade se encontra em manutenção. Saiba mais em https://discord.gg/newvalleyrp.')	
			return
		end
	end

	if not quantum.isWhitelisted(user_id) then
		local message = "Olá, "..name..", você não possui whitelist! Para se inscrever, acesse https://discord.gg/newvalleyrp. Seu identificador: "..user_id
		local jsonContent = LoadResourceFile(GetCurrentResourceName(), 'whitelist_card.json')
		jsonContent = jsonContent:gsub("${name}", name):gsub("${user_id}", user_id)

		deferrals.presentCard(jsonContent, function(actionData)
			if actionData and actionData.action == "closeCard" then
				deferrals.done(message)
			else
				deferrals.done("Ação inválida.")
			end
		end)
		return
	end
	
	

	if (cacheUsers.rusers[user_id] == nil) then
		local userTable = quantum.getUData(user_id, 'quantum:userTable')
		cacheUsers.users[ids[1]] = user_id
		cacheUsers.rusers[user_id] = ids[1]
		cacheUsers.user_source[user_id] = source
		cacheUsers.user_tables[user_id] = {}

		local data = (json.decode(userTable) or {})
		if (type(data) == 'table') then cacheUsers.user_tables[user_id] = data end

		TriggerEvent('quantum:playerJoin', source, user_id)

		local steamURL, steamID, discord = formatIdentifiers(source)
		quantum.webhook('Join', '```prolog\n[quantum FRAMEWORK]\n[ACTION]: (JOIN)\n[USER]: '..user_id..'\n[IP]: '..(GetPlayerEndpoint(source) or '0.0.0.0')..'\n[IDENTIFIERS]: '..json.encode(GetPlayerIdentifiers(source), { indent = true })..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\r```'..steamURL..steamID..discord)
		quantum.execute('quantum_framework/setLogin', { user_id = user_id, ip = (GetPlayerEndpoint(source) or '0.0.0.0') })
	else
		TriggerEvent('quantum:playerRejoin', source, user_id)
	end
	deferrals.done()	
end)

quantum.checkWhitelist = function(target)
	local source = source
	if (target) then source = target; end;
	local user_id = quantum.getUserId(source)
	if (user_id) then return quantum.isWhitelisted(user_id); end;
end

quantum.setWhitelisted = function(user_id, whitelisted)
	quantum.execute('quantum_framework/setWhitelist', { user_id = user_id, whitelist = whitelisted })
end

quantum.isWhitelisted = function(user_id)
	if (user_id) then
		local rows = quantum.query('quantum_framework/getWhitelist', { user_id = user_id })[1]
		if (rows) and rows.whitelist == 1 then
			return true
		end
	end
	return false
end
exports('isWhitelisted', quantum.isWhitelisted)

function GetUserWhitelistStatus(id)
    local result = exports.oxmysql:executeSync('SELECT whitelist FROM users WHERE id = @id', {
        ['@id'] = id
    })
    if result[1] and result[1].whitelist then
        return result[1].whitelist
    else
        return 0 -- Caso não encontre, consideramos que o jogador não tem whitelist
    end
end

AddEventHandler('playerDropped', function(reason)
	local source = source
	quantum.dropPlayer(source, reason)
end)

quantum.dropPlayer = function(source, reason)
	local source = source
	if (source) then
		local user_id = quantum.getUserId(source)
		if (user_id) then
			local userTable = quantum.getUserDataTable(user_id)
			local ped = GetPlayerPed(source)
			local pCoord = GetEntityCoords(ped)

			TriggerEvent('quantum:playerLeave', user_id, source)
			TriggerClientEvent('quantum:playerExit', -1, user_id, reason, pCoord)

			userTable.health = GetEntityHealth(ped)
			userTable.armour = GetPedArmour(ped)
			userTable.Handcuff = Player(source).state.Handcuff
			userTable.Capuz = Player(source).state.Capuz
			userTable.GPS = Player(source).state.GPS

			local steamURL, steamID, discord = formatIdentifiers(source)
			local health, weapons = userTable.health, concatArmas(userTable.weapons)
			
			quantum.webhook('Exit', '```prolog\n[quantum FRAMEWORK]\n[ACTION]: (LEAVE)\n[REASON]: '..reason..'\n[USER]: '..user_id..'\n[IP]: '..(GetPlayerEndpoint(source) or '0.0.0.0')..'\n[IDENTIFIERS]: '..json.encode(GetPlayerIdentifiers(source), { indent = true })..'\n\n[USER INFOS]\n[HEALTH]: '..((health > 100) and health or 'DIED')..'\n[COORDS]: '..tostring(pCoord)..'\n[INVENTORY]: '..concatInv(quantum.getInventory(user_id))..'\n[WEAPONS]: '..weapons..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\r```'..steamURL..steamID..discord)
			quantum.setUData(user_id, 'quantum:userTable', json.encode(userTable))
			
			-- cacheUsers.users[] = nil
			cacheUsers.rusers[user_id] = nil
			cacheUsers.user_source[user_id] = nil
			cacheUsers.user_tables[user_id] = nil
		end
	end
end
vRP.dropPlayer = quantum.dropPlayer

RegisterNetEvent('quantumClient:playerSpawned', function()
	local source = source
	local user_id = quantum.getUserId(source)
	if (user_id) then
		local firstSpawn = cacheUsers.firstSpawn[user_id]
		if (firstSpawn == nil) then
			firstSpawn = 1
			Tunnel.setDestDelay(source, 0)
		else
			firstSpawn = 0
		end
		cacheUsers.user_source[user_id] = source
		TriggerEvent('quantum:playerSpawn', user_id, source, firstSpawn)
	else
		local user_id = quantum.getUserIdByIdentifiers(GetPlayerIdentifiers(source))
		cacheUsers.rusers[user_id] = nil
		DropPlayer(source, 'Você está com o ID bugado! Reloga e tente novamente. Isso é para evitar Cheat, se isso apareceu para você, Cuidado.')
		print('[BUG SOURCE]', 'USER_ID: '..user_id, 'SOURCE: '..source)
		quantum.webhook('BugSource', '```prolog\n[quantum FRAMEWORK]\n[ACTION]: (Invalid Source)\n[SOURCE]: '..tostring(source)..'\n[IDS]: '..json.encode(GetPlayerIdentifiers(source), { indent = true })..'```')	
	end
end)

quantum.prompt = function(source, questions)
	return exports['quantum_hud']:prompt(source, questions)
end
vRP.prompt = quantum.prompt

quantum.request = function(source, title, time)
	return exports['quantum_hud']:request(source, title, time)
end
vRP.request = quantum.request

quantum.getDayHours = function(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    if (days > 0) then
        return string.format('<b>%d Dias</b> e <b>%d Horas</b>', days, hours)
    else
        return string.format('<b>%d Horas</b>', hours)
    end
end
vRP.getDayHours = quantum.getDayHours

quantum.getMinSecs = function(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60

    if (minutes > 0) then
        return string.format('<b>%d Minutos</b> e <b>%d Segundos</b>', minutes, seconds)
    else
        return string.format('<b>%d Segundos</b>', seconds)
    end
end
vRP.getMinSecs = quantum.getMinSecs

local delayflood = {}
local flood = {}

quantum.antiflood = function(source, key, limite)
	if(flood[key]==nil or delayflood[key] == nil)then 
		flood[key]={}
		delayflood[key]={}
	end
    if(flood[key][source]==nil)then
        flood[key][source] = 1
        delayflood[key][source] = os.time()
    else
        if(os.time()-delayflood[key][source]<1)then
            flood[key][source]= flood[key][source] + 1
            if(flood[key][source]==limite)then
                local user_id = quantum.getUserId(source)
				exports['quantum_core']:setBanned(user_id, true)
                DropPlayer(source, "Ih rapá, se fudeu KKKKKKKKKKKKKK")
				quantum.webhook('AntiFlood', "```prolog\n[ID]: "..user_id.." \n[ANTI-FLOOD]: "..key.."\n"..os.date("\n\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```" )
            end
        else
            flood[key][source]=nil
            delayflood[key][source] = nil
        end
        delayflood[key][source] = os.time()
    end
end
vRP.antiflood = quantum.antiflood

task_save_datatables = function()
	SetTimeout(5000, task_save_datatables); 
	for k, v in pairs(cacheUsers.user_tables) do
		quantum.setUData(k, 'quantum:userTable', json.encode(v))
	end
end

async(task_save_datatables)

local webhookCrash = 'https://discord.com/api/webhooks/1073755441592533002/73gJnK61b7W6sPht4uKDjNnDs--BtZw_5dIfVeYwxeR1Hga1SbsBkZRMr6jj0-Hj2Er5'
 AddEventHandler('playerDropped', function(reason)
     local _source = source
 	if (_source) then
 		quantum.dropPlayer(_source, reason)

 		local user_id = quantum.getUserId(_source)
 		if user_id then
 			if (reason == "Game crashed: gta-core-five.dll!CrashCommand (0x0)") then
 				quantum.setBanned(user_id, true)
 				exports["quantum_core"]:insertBanRecord(user_id,true,-1,"FORÇOU CRASH")
 				quantum.webhook(webhookCrash, "```prolog\n[USER_ID]: "..user_id.."\n[UTILIZOU COMANDO _CRASH]"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```" )
			end
 		end
 	end
 end)