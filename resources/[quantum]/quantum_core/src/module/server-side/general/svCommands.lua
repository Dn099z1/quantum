local srv = {}
Tunnel.bindInterface('Commands', srv)
local vCLIENT = Tunnel.getInterface('Commands')

---------------------------------------
-- ME
---------------------------------------
srv.checkPermission = function(perm)
    local source = source
    local user_id = quantum.getUserId(source)
    return quantum.checkPermissions(user_id, perm)
end

---------------------------------------
-- ME
---------------------------------------
local meWebhook = 'dndcwebhook/webhooks/1149090557696679966/DM9FgQRU_lXFMkaqYVdZJaPyKwEaCQlVcBewYJWgHre_JUJ2r0t5zkeFE55p5RwERfZ_'
RegisterCommand('me', function(source, args, raw)
    local user_id = quantum.getUserId(source)
    if (user_id) then
        if (GetEntityHealth(GetPlayerPed(source)) > 101) then
            TriggerClientEvent('DisplayMe', -1, raw:sub(3), source)
            quantum.webhook(meWebhook, '```prolog\n[/ME]\n[USER]: '..user_id..'\n[TEXT]:'..raw:sub(3)..'\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
        end
    end
end)

---------------------------------------
-- GIVE INVENTORY ITEM
---------------------------------------
srv.giveInventoryItem = function(item)
    local source = source
    local user_id = quantum.getUserId(source)
    quantum.giveInventoryItem(user_id, item, 1)
end

---------------------------------------
-- DELETE ALL OBJECTS
---------------------------------------
RegisterCommand('dobjall', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Moderador') then
        local count = 0
        for _, v in pairs(GetAllObjects()) do
            if (DoesEntityExist(v)) then
                DeleteEntity(v)
                count = count + 1
            end
        end
        TriggerClientEvent('announcement', -1, 'Alerta', 'Foi deletado <b>'..count..' objetos</b> da nossa cidade.', 'Governo', true, 30000)
    end
end)

---------------------------------------
-- GOD
---------------------------------------
RegisterCommand('revive', function(source, args)
    local _userId = quantum.getUserId(source)
    if (_userId) and quantum.hasPermission(_userId, 'staff.permissao') then
        local _identity = quantum.getUserIdentity(_userId)
        if (args[1]) then
            local other_id = parseInt(args[1])
            local nPlayer = quantum.getUserSource(other_id)
            if (nPlayer) then
                quantumClient.killGod(nPlayer)
                quantumClient.setHealth(nPlayer, 200) 
                quantum.varyHunger(other_id, -100)     
                quantum.varyThirst(other_id, -100)          
			end
        else
            quantumClient.killGod(source)
			quantumClient.setHealth(source, 200)
            quantum.varyHunger(_userId, -100)     
            quantum.varyThirst(_userId, -100)    
        end
        quantum.webhook('God', '```prolog\n[/GOD]\n[STAFF]: #'.._userId..' '.._identity.firstname..' '.._identity.lastname..' \n[REVIVEU]: '..(args[1] or _userId)..'\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- GODALL
---------------------------------------
RegisterCommand('reviveall', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        local users = quantum.getUsers()
        for k, v in pairs(users) do
            local id = quantum.getUserSource(parseInt(k))
            if (id) then
            	quantumClient._killGod(id)
				quantumClient._setHealth(id, 200)
            end
        end
        quantum.webhook('GodAll', '```prolog\n[/GODALL]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[REVIVEU]: TODOS!\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- GODALL
---------------------------------------
RegisterCommand('revivearea', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        local radius = quantum.prompt(source, { 'Distancia' })
        radius[1] = parseInt(radius[1])
        if (radius[1]) and radius[1] > 0 then
            local players = quantumClient.getNearestPlayers(source, radius[1])
            for k, v in pairs(players) do
                quantumClient._killGod(k)
				quantumClient._setHealth(k, 200) 
            end
            quantum.webhook('GodArea', '```prolog\n[/GODAREA]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[ÁREA]: '..radius[1]..'\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

---------------------------------------
-- FREEZE
---------------------------------------
RegisterCommand('freeze', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nSource = quantum.getUserSource(parseInt(args[1]))
            if (nSource) then
                local ped = GetPlayerPed(nSource)
                TriggerClientEvent('notify', source, 'Freeze', 'Você <b>freezou</b> o jogador!')
                TriggerClientEvent('notify', nSource, 'Freeze', 'Você foi <b>freezado</b> por um staff!')
                FreezeEntityPosition(ped, true)
            end
        else
            local ped = GetPlayerPed(source)
            TriggerClientEvent('notify', source, 'Freeze', 'Você se <b>freezou</b>!')
            FreezeEntityPosition(ped, true)
        end

        quantum.webhook('Freeze', '```prolog\n[/FREEZE]\n[USER]: '..user_id..'\n[TARGET]: '..(args[1] and args[1] or user_id)..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
    end
end)

RegisterCommand('unfreeze', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nSource = quantum.getUserSource(parseInt(args[1]))
            if (nSource) then
                local ped = GetPlayerPed(nSource)
                TriggerClientEvent('notify', source, 'Freeze', 'Você <b>desfreezou</b> o jogador!')
                TriggerClientEvent('notify', nSource, 'Freeze', 'Você foi <b>desfreezado</b> por um staff!')
                FreezeEntityPosition(ped, false)
            end
        else
            local ped = GetPlayerPed(source)
            TriggerClientEvent('notify', source, 'Freeze', 'Você se <b>desfreezou</b>!')
            FreezeEntityPosition(ped, false)
        end

        quantum.webhook('Freeze', '```prolog\n[/UNFREEZE]\n[USER]: '..user_id..'\n[TARGET]: '..(args[1] and parseInt(args[1]) or user_id)..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
    end
end)


---------------------------------------
-- WALL
---------------------------------------
srv.getWallId = function(sourceplayer)
    if (sourceplayer ~= nil and parseInt(sourceplayer) > 0) then
        return quantum.getUserId(sourceplayer), Player(sourceplayer).state.Cam
    end
end


---------------------------------------
-- KILL
---------------------------------------
RegisterCommand('kill', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Moderador') then
        if (args[1]) then
            local nPlayer = quantum.getUserSource(parseInt(args[1]))
            if (nPlayer) then
                quantumClient.killGod(nPlayer)
                quantumClient.setHealth(nPlayer, 0)
                quantumClient.setArmour(nPlayer, 0)
            end
        else
            quantumClient.killGod(source)
            quantumClient.setHealth(source, 0)
            quantumClient.setArmour(source, 0)
        end
        quantum.webhook('Kill', '```prolog\n[ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[MATOU]: '..(args[1] or user_id)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- KICK
---------------------------------------
RegisterCommand('kick', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local prompt = quantum.prompt(source, { 'Motivo' })
            if (prompt) then
                prompt = prompt[1]
                local nPlayer = quantum.getUserSource(parseInt(args[1]))
                if (nPlayer) then
                    DropPlayer(nPlayer, 'Você foi kikado da nossa cidade.\nSeu passaporte: #'..args[1]..'\n Motivo: '..prompt..'\nAutor: '..identity.firstname..' '..identity.lastname)
                    TriggerClientEvent('notify', source, 'Kick', 'Voce kickou o passaporte <b>'..args[1]..'</b> da cidade.')
                    quantum.webhook('Kick', '```prolog\n[/KICK]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[KICKOU]: '..args[1]..'\n[MOTIVO]: '..prompt..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
                end
            end
        end
    end
end)

---------------------------------------
-- KICKALL
---------------------------------------
RegisterCommand('kickall', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        TriggerClientEvent('announcement', -1, 'Alerta', 'Foi detectado um terremoto de <b>magnitude 8</b> na <b>Escala Richter</b> chegando em nossa cidade. Mantenha a calma e procure um abrigo.', 'Governo', true, 30000)
        Citizen.Wait(5000)
        MySQL.Async.execute('DELETE FROM spray', {}, function(affectedRows) end)
        TriggerClientEvent('quantum_core:terremoto', -1)
        Citizen.Wait(15000)
        local players = quantum.getUsers()
        for k, v in pairs(players) do
            local nSource = quantum.getUserSource(parseInt(k))
            if (nSource) then
                DropPlayer(nSource, 'Você foi vítima de um terremoto.')
                quantum.webhook('KickAll', '```prolog\n[/KICKALL]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[KICKOU]: TODOS!'..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            end
        end
    end
end)

---------------------------------------
-- WL
---------------------------------------
RegisterCommand('whitelist', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') and args[1] then
        local nUser = parseInt(args[1])
        if (nUser) then
            exports['quantum']:setWhitelisted(nUser, true)
            TriggerClientEvent('notify', source, 'Whitelist', 'Você aprovou o passaporte <b>'..nUser..'</b> na whitelist.')
            quantum.webhook('Whitelist', '```prolog\n[/WL]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[APROVOU WL]: '..args[1]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

RegisterCommand('removewl', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') and args[1] then
        local nUser = parseInt(args[1])
        if (nUser) then
            exports['quantum']:setWhitelisted(nUser, false)
            TriggerClientEvent('notify', source, 'Whitelist', 'Você retirou o passaporte <b>'..nUser..'</b> da whitelist.')
            quantum.webhook('Whitelist', '```prolog\n[/UNWL]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[RETIROU WL]: '..args[1]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

---------------------------------------
-- BANIMENTO
---------------------------------------
RegisterCommand('ban', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') and args[1] then
        local nUser = parseInt(args[1])
        if (quantum.isBanned(nUser)) then TriggerClientEvent('notify', source, 'Desbanimento', 'Este <b>jogador</b> já está banido seu noia!') return; end;
        local prompt = quantum.prompt(source, { 'Motivo' })
        if (prompt) then
            prompt = prompt[1]

            local nPlayer = quantum.getUserSource(nUser)
            if (nPlayer) then
                DropPlayer(nPlayer, 'Você foi banido da nossa cidade.\nSeu passaporte: #'..nUser..'\n Motivo: '..prompt..'\nAutor: '..identity.firstname..' '..identity.lastname)
            end
            exports[GetCurrentResourceName()]:setBanned(nUser, true)
            exports[GetCurrentResourceName()]:insertBanRecord(nUser, true, user_id, '[BAN] '..prompt..'!')
            TriggerClientEvent('notify', source, 'Banimento', 'Você baniu o passaporte <b>'..nUser..'</b> da cidade.')
            quantum.webhook('Ban', '```prolog\n[/BAN]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[BANIU]: '..nUser..'\n[MOTIVO]: '..prompt..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

RegisterCommand('removeban', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Manager') and args[1] then
        local nUser = parseInt(args[1])
        if (nUser > 0) then
            if (not quantum.isBanned(nUser)) then TriggerClientEvent('notify', source, 'Desbanimento', 'Este <b>jogador</b> não está banido seu noia!') return; end;

            local prompt = quantum.prompt(source, { 'Motivo' })
            if (prompt) then
                prompt = prompt[1]
                
                exports[GetCurrentResourceName()]:setBanned(nUser, false)
                exports.quantum_core:insertBanRecord(nUser, false, user_id, '[UNBAN] desbanido!')
                TriggerClientEvent('notify', source, 'Desbanimento', 'Você desbaniu o passaporte <b>'..nUser..'</b> da cidade.')
                quantum.webhook('Ban', '```prolog\n[/UNBAN]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[DESBANIU]: '..nUser..'\n[MOTIVO]: '..prompt..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            end
        end
    end
end)

---------------------------------------
-- MONEY
---------------------------------------
RegisterCommand('givebank', function(source, args)
	local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.COO') then
        if (not user_id == 1 and not user_id == 2 and not user_id == 3) then return; end;
        local amount = parseInt(args[1])
		if (amount) then
			quantum.giveBankMoney(user_id, amount)
            --exports.qbank:extrato(user_id, 'Prefeitura', amount)
            TriggerClientEvent('notify', source, 'Money', 'Você spawnou <b>R$'..quantum.format(amount)..'</b>.')
			quantum.webhook('Money', '```prolog\n[/MONEY]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[MONEY]: R$'..quantum.format(amount)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
		end
	end
end)




---------------------------------------
-- NOCLIP
---------------------------------------
RegisterCommand('nc', function(source)
	local _userId = quantum.getUserId(source)
    if (_userId) and quantum.hasPermission(_userId, 'staff.permissao') then
        local _identity = quantum.getUserIdentity(_userId)
		quantumClient.toggleNoclip(source) 
        quantum.webhook('NoClip', '```prolog\n[/NC]\n[STAFF]: #'.._userId..' '.._identity.firstname..' '.._identity.lastname..' \n[NOCLIP]: '..tostring(quantumClient.isNoclip(source))..'\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')    
	end
end)

---------------------------------------
-- COORDS
---------------------------------------
RegisterCommand('vec', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        TriggerClientEvent('clipboard', source, 'Vector3', tostring(GetEntityCoords(GetPlayerPed(source))))
    end
end)

RegisterCommand('vec2', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local pCoord = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent('clipboard', source, 'Vector2', 'vector2('..pCoord.x..', '..pCoord.y..')')
    end
end)

RegisterCommand('h', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        TriggerClientEvent('clipboard', source, 'Heading', tostring(GetEntityHeading(GetPlayerPed(source))))
    end
end)

---------------------------------------
-- TPWAY
---------------------------------------
RegisterCommand('tpway', function(source)
	local _userId = quantum.getUserId(source)
    if (_userId) and quantum.hasPermission(_userId, 'staff.permissao') then
        local _identity = quantum.getUserIdentity(_userId)
        vCLIENT.tpToWayFunction(source)
        quantum.webhook('TpWay', '```prolog\n[/TPWAY]\n[STAFF]: #'.._userId..' '.._identity.firstname..' '.._identity.lastname..'\n[TELEPORTOU]: PARA WAYPOINT\n[COORD]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- TPCDS
---------------------------------------
RegisterCommand('tpcds', function(source)
    local _userId = quantum.getUserId(source)
    if (_userId) and quantum.hasPermission(_userId, 'staff.permissao') then
        local _identity = quantum.getUserIdentity(_userId)
        local promptCoords = quantum.prompt(source, { 'Coordenadas' })
        if (not promptCoords) then return; end;

        local coords = {}
        for coord in string.gmatch(sanitizeString(promptCoords[1], '0123456789,-.',true) ,'[^,]+') do
			table.insert(coords, (tonumber(coord) or 0))
		end

        SetEntityCoords(GetPlayerPed(source), (coords[1] or 0), (coords[2] or 0), (coords[3] or 0))
        quantum.webhook('Teleport', '```prolog\n[/TPCDS]\n[STAFF]: #'.._userId..' '.._identity.firstname..' '.._identity.lastname..'\n[TELEPORTOU]: '..tostring(vector3((coords[1] or 0), (coords[2] or 0), (coords[3] or 0)))..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- TPCDS
---------------------------------------
RegisterCommand('teleportto', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nPlayer = quantum.getUserSource(parseInt(args[1]))
            if (nPlayer) then
                local nUser = quantum.getUserId(nPlayer)
                local nIdentity = quantum.getUserIdentity(nUser)
                if (not nIdentity) then return; end;
                local nCoords = GetEntityCoords(GetPlayerPed(nPlayer))
                quantum.webhook('TeleportTo', '```prolog\n[/TPTO]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[FOI ATÉ]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..'\n[COORDENADA]: '..tostring(nCoords)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')    
                SetEntityCoords(source, nCoords)
            end
        end
    end
end)

---------------------------------------
-- TPTOME
---------------------------------------
RegisterCommand('teleporttome', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nPlayer = quantum.getUserSource(parseInt(args[1]))
            if (nPlayer) then
                local nUser = quantum.getUserId(nPlayer)
                local nIdentity = quantum.getUserIdentity(nUser)
                local pCoords = GetEntityCoords(GetPlayerPed(source))
                quantumClient.teleport(nPlayer, pCoords.x, pCoords.y, pCoords.z)
                quantum.webhook('TeleportTo', '```prolog\n[/TPTOME]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[PUXOU]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..'\n[COORDENADA]: '..tostring(pCoords)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')    
            end
        end
    end
end)


---------------------------------------
-- RMASCARA
---------------------------------------
RegisterCommand('removemascara', function(source)
	local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (user_id) and quantum.hasPermission(user_id, 'polpar.permissao') then
		local nplayer = quantumClient.getNearestPlayer(source, 2)
		if (nplayer) then
            local nUser = quantum.getUserId(nplayer)
			local nIdentity = quantum.getUserIdentity(nUser)
			TriggerClientEvent('quantum_commands_police:clothes', nplayer, 'rmascara')
			quantum.webhook('PoliceCommands', '```prolog\n[/RMASCARA]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[RETIROU A MASCARA DO]\n[JOGADOR]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        else
            TriggerClientEvent('notify', source, 'Remover Máscara', 'Você não se encontra próximo de um <b>cidadão</b>.')
        end
	end
end)

---------------------------------------
-- TOW
---------------------------------------
RegisterServerEvent('trytow', function(vehid01, vehid02, mod)
	TriggerClientEvent('synctow', -1, vehid01, vehid02, mod)
end)

---------------------------------------
-- ANÚNCIOS
---------------------------------------
RegisterCommand('admin', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity =  quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local message = quantum.prompt(source, { 'Mensagem' })
        if (message) then
            message = message[1]

            TriggerClientEvent('announcement', -1, 'Prefeitura', message, identity.firstname, true, 30000)
            quantum.webhook('Anuncios', '```prolog\n[/ADM]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[MENSAGEM]: '..message..' \n[COORDENADA]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

RegisterCommand('announce', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity =  quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'polpar.permissao') or quantum.hasPermission(user_id, 'mecanico.permissao') then
        local message = quantum.prompt(source, { 'Título', 'Mensagem' })
        if (message) then
            TriggerClientEvent('announcement', -1, message[1], message[2], identity.firstname, true, 30000)
            quantum.webhook('Anuncios', '```prolog\n[/ANUNCIO]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[TÍTULO]: '..message[1]..'\n[MENSAGEM]: '..message[2]..' \n[COORDENADA]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end
    end
end)

---------------------------------------
-- CAR COLOR
---------------------------------------
RegisterCommand('ccolor', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        local vehicle = quantumClient.getNearestVehicle(source, 7.0)
        if (vehicle) then
            local prompt = quantum.prompt(source, { 'Primary Color RGB (255, 255, 255)', 'Secondary Color RGB (255, 255, 255)' })
            if (prompt) then
                local primary = prompt[1]
                if (primary) then
                    local rgb = sanitizeString(primary, '0123456789,', true)
                    local r, g, b = table.unpack(splitString(rgb, ','))
                    TriggerClientEvent('quantum_core:carcolor', source, vehicle, parseInt(r), parseInt(g), parseInt(b), true)   
                    TriggerClientEvent('notify', source, 'Car Color','A cor primária do <b>veículo</b> foi alterada.')
                end

                local secondary = prompt[2]
                if (secondary) then
                    local rgb = sanitizeString(secondary, '0123456789,', true)
                    local r, g, b = table.unpack(splitString(rgb, ','))
                    TriggerClientEvent('quantum_core:carcolor', source, vehicle, parseInt(r), parseInt(g), parseInt(b), false)   
                    TriggerClientEvent('notify', source, 'Car Color','A cor secundária do <b>veículo</b> foi alterada.')
                end

                local text, text2 = (primary and primary or '(NONE)'), (secondary and secondary or '(NONE)')
                quantum.webhook('CarColor', '```prolog\n[/CARCOLOR]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[RGB PRIMARY]: '..text..'\n[RGB SECONDARY]: '..text2..' \n[COORDS]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..'\n'..os.date('[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            end
        end
    end
end)

---------------------------------------
-- UNCUFF
---------------------------------------
RegisterCommand('uncuff', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        if (args[1]) then
            local nSource = quantum.getUserSource(parseInt(args[1]))
            if (quantumClient.isHandcuffed(nSource)) then
                Player(nSource).state.Handcuff = false
                quantumClient.setHandcuffed(nSource, false)
                TriggerClientEvent('quantum_core:uncuff', nSource)
            else
                TriggerClientEvent('notify', source, 'Uncuff', 'O jogador não se encontra <b>algemado</b>.')
            end
        else
            if (quantumClient.isHandcuffed(source)) then
                Player(source).state.Handcuff = false
                quantumClient.setHandcuffed(source, false)
                TriggerClientEvent('quantum_core:uncuff', source)
            else
                TriggerClientEvent('notify', source, 'Uncuff', 'Você não se encontra <b>algemado</b>.')
            end
        end

        local text = (not args[1] and user_id or args[1])
        quantum.webhook('Uncuff', '```prolog\n[/UNCUFF]\n[USER]: '..user_id..'\n[TARGET]: '..text..' \n[COORDS]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..'\n'..os.date('[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- RCAPUZ
---------------------------------------
RegisterCommand('removehood', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        if (args[1]) then
            local nSource = quantum.getUserSource(parseInt(args[1]))
            if (quantumClient.isCapuz(nSource)) then
                Player(nPlayer).state.Capuz = false
                quantumClient.setCapuz(nSource, false)
            else
                TriggerClientEvent('notify', source, 'Remover capuz', 'O jogador não se encontra <b>encapuzado</b>.')
            end
        else
            if (quantumClient.isCapuz(source)) then
                Player(source).state.Capuz = false
                quantumClient.setCapuz(source, false)
            else
                TriggerClientEvent('notify', source, 'Remover capuz', 'Você não se encontra <b>encapuzado</b>.')
            end
        end

        local text = (not args[1] and user_id or args[1])
        quantum.webhook('Uncuff', '```prolog\n[/UNCUFF]\n[USER]: '..user_id..'\n[TARGET]: '..text..' \n[COORDS]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..'\n'..os.date('[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- LIMPARAREA
---------------------------------------
RegisterCommand('cleanarea', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local pCoord = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent('syncarea', -1, pCoord.x, pCoord.y, pCoord.z)
        quantum.webhook('LimparArea', '```prolog\n[/LIMPARAREA]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[COORDS]: '..tostring(pCoord)..'\n'..os.date('[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- SKIN
---------------------------------------
RegisterCommand('ped', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.COO') then
        local text = ''
        local nPlayer = quantum.getUserSource(parseInt(args[1]))
        if (args[2]) and nPlayer then  
            local nUser = quantum.getUserId(nPlayer)
            local nIdentity = quantum.getUserIdentity(nUser)
            vCLIENT.skinModel(nPlayer, args[2])
            TriggerClientEvent('notify', source, 'Skin', 'Você setou a skin <b>'..args[2]..'</b> no passaporte <b>'..nUser..'</b>.')
            text = '#'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..'\n[SKIN]: '..args[2]
        else
            vCLIENT.skinModel(source, args[1])
            TriggerClientEvent('notify', source, 'Skin', 'Você setou a skin <b>'..args[1]..'</b> em si mesmo.')
            text = '#'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[SKIN]: '..args[1]
        end
        quantum.webhook('Skin', '```prolog\n[/SKIN]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[JOGADOR]: '..text..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- TRY DELETE OBJ
---------------------------------------
RegisterNetEvent('trydeleteobj', function(index)
    local entity = NetworkGetEntityFromNetworkId(index)
    if (entity and entity ~= 0) then DeleteEntity(entity) end
end)

---------------------------------------
-- DEL NPCS
---------------------------------------
RegisterCommand('deletepeds',function(source)
    local source = source
	local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
		TriggerClientEvent('quantum_core:delnpcs', source)
        quantum.webhook('DeleteNpc', '```prolog\n[/DELNPCS]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
	end
end)

RegisterNetEvent('trydeleteped', function(index)
	TriggerClientEvent('syncdeleteped', -1, index)
end)

---------------------------------------
-- TUNING
---------------------------------------
RegisterCommand('tune', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.COO') then
        TriggerClientEvent('quantum_core:tuning', source)
        quantum.webhook('Tuning', '```prolog\n[/TUNING]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- DEBUG
---------------------------------------
RegisterCommand('devmode', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        TriggerClientEvent('quantum_core:debug', source)
    end
end)

---------------------------------------
-- CLEAR WEAPONS
---------------------------------------
RegisterCommand('removeweapons', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        local text = ''
        if (args[1]) then
            local nSource = quantum.getUserSource(parseInt(args[1]))
            if (nSource) then
                local nUser = quantum.getUserId(nSource)
                local nIdentity = quantum.getUserIdentity(nUser)
                quantumClient.giveWeapons(nSource, {}, true, GlobalState.weaponToken)
                TriggerClientEvent('notify', source, 'Clear Weapon', 'Você limpou os <b>armamentos</b> do passaporte <b>'..nUser..'</b>.')
                text = '#'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname
            end
        else
            quantumClient.giveWeapons(source, {}, true, GlobalState.weaponToken)
            TriggerClientEvent('notify', source, 'Clear Weapon', 'Você limpou os seus <b>armamentos</b>')
            text = '#'..user_id..' '..identity.firstname..' '..identity.lastname
        end
        quantum.webhook('ClearWeapons', '```prolog\n[/CLEARWEAPONS]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[LIMPOU AS ARMAS DO]: '..text..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
    end
end)

---------------------------------------
-- VROUPAS
---------------------------------------
RegisterCommand('takeclothes',function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local custom = quantumClient.getCustomization(source)
        local content = {}
        for k, v in pairs(custom) do
            if (v ~= GetEntityModel(GetPlayerPed(source))) then
                if (string.sub(k, 1, 1) == 'p') then
                    k = "['"..k.."']"
                else
                    k = '['..k..']'
                end
                table.insert(content, k..' = { model = '..v.model..', var = '..v.var..', palette = '..v.palette..' },') 
            end
        end
        content = table.concat(content, '\n ')
        TriggerClientEvent('clipboard', source, 'Código da roupa', content)
    end
end)

---------------------------------------
-- UMSG
---------------------------------------
RegisterCommand('privatemsg', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local message = quantum.prompt(source, { 'Mensagem' })
            if (message) then
                message = message[1]

                local nPlayer = quantum.getUserSource(parseInt(args[1]))
                if (nPlayer) then
                    local nUser = quantum.getUserId(nPlayer)
                    local nIdentity = quantum.getUserIdentity(nUser)
                    TriggerClientEvent('notify', nPlayer, 'Mensagem Privada', 'O staff <b>'..identity.firstname..' '..identity.lastname..'</b> te enviou uma mensagem: <br /><br />'..message, 10000)
                    TriggerClientEvent('notify', source, 'Mensagem Privada', 'A mensagem foi enviada com <b>sucesso</b>.')
                    quantumClient.playSound(source, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset')
					quantumClient.playSound(nPlayer, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset')
					Citizen.Wait(100)
					quantumClient.playSound(nPlayer, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset')
					Citizen.Wait(100)
					quantumClient.playSound(nPlayer, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset')
                    quantum.webhook('Umsg', '```prolog\n[/UMSG]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[FALOU COM]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..' \n[MENSAGEM]: '..message..os.date('\n[DATA]: %d/%m/%Y - [HORA]: %H:%M:%S')..' \r```')
                end
            end
        end
    end
end)

---------------------------------------
-- BANSRC
---------------------------------------
RegisterCommand('bansource', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nSource = parseInt(args[1])
            if (nSource) then
                if (GetPlayerName(nSource)) then
                    local nUser = quantum.getUserIdByIdentifiers(GetPlayerIdentifiers(nSource))
                    if (nUser ~= -1) then
                        local prompt = quantum.prompt(source, { 'Motivo' })

                        if (prompt) then
                            prompt[1] = prompt[1]
                            
                            exports[GetCurrentResourceName()]:setBanned(nUser, true)
                            exports.quantum_core:insertBanRecord(nUser, true, user_id, '[BANSRC] source banida!')
                            DropPlayer(nSource, 'Você foi banido da nossa cidade.\nSeu passaporte: #'..nUser..'\n Motivo: '..prompt[1]..'\nAutor: '..identity.firstname..' '..identity.lastname)
                            TriggerClientEvent('notify', source, 'Banimento', 'Você baniu a source <b>'..nSource..'</b> da cidade.')
                            quantum.webhook('BanSource', '```prolog\n[/BANSRC]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[BANIU SOURCE]: '..nSource..' \n[ID RELACIONADO]: '..nUser..'\n[MOTIVO]: '..prompt[1]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------
-- TPTO SRC
---------------------------------------
RegisterCommand('tptosource', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            SetEntityCoords(source, GetEntityCoords(GetPlayerPed(parseInt(args[1]))))
        end
    end
end)

---------------------------------------
-- CHECK BUGADO
---------------------------------------
RegisterCommand('checkbug', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local message = ''
        for _, v in ipairs(GetPlayers()) do 
            local pName = GetPlayerName(v)
            local uId = quantum.getUserId(tonumber(v))
            if (not uId) then 
                message = message .. string.format('</br> <b>%s</b> | Source: <b>%s</b> | Ready: %s',pName,v,((Player(v).state.ready) and 'Sim' or 'Não'))
            end
        end
        TriggerClientEvent('notify', source, 'Check Bugados', ((message ~= '') and message or 'Sem usuários bugados no momento!'))
    end
end)



---------------------------------------
-- SCREENSHOT SOURCE
---------------------------------------
RegisterCommand('screensource', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        local nSource = parseInt(args[1])
        if (nSource > 0) then
            local ids = quantum.getIdentifiers(nSource)
            exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(nSource, 'dndcwebhook/webhooks/1316929928435863572/1caYEreTHcC9DP6Zp5cn_P4Ow4YxOn2g0X3UCh2JYFOzb1QtGzjgeF6phq86Yx7a-H1R', { encoding = 'jpg', quality = 0.7 },
                {
                    username = '[SCREENSHOT] Source',
                    content = '```prolog\n[SOURCE]: '..nSource..'\n[IDS]: '..json.encode(ids, { indent = true })..' \n[Admin]: '..GetPlayerName(source)..'```'
                }, 30000, function(error) end
            )
        end
    end
end)

---------------------------------------
-- KICK SOURCE
---------------------------------------
RegisterCommand('kicksource', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) then
            local nSource = parseInt(args[1])
            if (nSource) then
                if (GetPlayerName(nSource)) then
                    local prompt = quantum.prompt(source, { 'Motivo' })
                    if (prompt[1]) then
                        DropPlayer(nSource, 'Você foi kikado da nossa cidade.\nSua source: #'..nSource..'\n Motivo: '..prompt[1]..'\nAutor: '..identity.firstname..' '..identity.lastname)
                        TriggerClientEvent('notify', source, 'Kick Source', 'Voce kickou o source <b>'..args[1]..'</b> da cidade.')
                        quantum.webhook('KickSource', '```prolog\n[/KICKSRC]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[BANIU SOURCE]: '..nSource..' \n[MOTIVO]: '..prompt[1]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
                    end
                end
            end
        end
    end
end)

---------------------------------------
-- RESET PLAYER
---------------------------------------
local resetList = {}

local queries = {
    { query = 'DELETE FROM smartphone_blocks WHERE phone IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id) OR user_id = :user_id'},
    { query = 'DELETE FROM smartphone_calls WHERE target IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id) OR initiator IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_contacts WHERE owner IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id) OR phone IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_gallery WHERE user_id = :user_id'},
    { query = 'DELETE FROM smartphone_bank_invoices WHERE payee_id = :user_id OR payer_id = :user_id'},
    { query = 'DELETE FROM smartphone_instagram_followers WHERE profile_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id) OR follower_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_instagram_likes WHERE post_id IN (SELECT id FROM smartphone_instagram_posts WHERE profile_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id) AND post_id IS NULL) OR profile_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_instagram_notifications WHERE profile_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id) OR author_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_instagram_posts WHERE profile_id IN (SELECT id FROM smartphone_instagram WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_instagram WHERE user_id = :user_id'},
    { query = 'DELETE FROM smartphone_olx WHERE user_id = :user_id'},
    { query = 'DELETE FROM smartphone_tinder_messages WHERE sender IN (SELECT id FROM smartphone_tinder WHERE user_id = :user_id) OR target IN (SELECT id FROM smartphone_tinder WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_tinder_rating WHERE profile_id IN (SELECT id FROM smartphone_tinder WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_tinder WHERE user_id = :user_id'},
    { query = 'DELETE FROM smartphone_twitter_tweets WHERE profile_id IN (SELECT id FROM smartphone_twitter_profiles WHERE user_id = :user_id) OR tweet_id IN (SELECT id FROM smartphone_twitter_profiles WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_twitter_likes WHERE profile_id IN (SELECT id FROM smartphone_twitter_profiles WHERE user_id = :user_id) OR tweet_id IN (SELECT id FROM smartphone_twitter_profiles WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_twitter_profiles WHERE user_id = :user_id'},
    { query = 'DELETE FROM smartphone_whatsapp_groups WHERE owner IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_whatsapp_messages WHERE channel_id IN (SELECT id FROM smartphone_whatsapp_channels WHERE sender IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id) OR target IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id))'},
    { query = 'DELETE FROM smartphone_whatsapp_channels WHERE sender IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id) OR target IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id)'},
    { query = 'DELETE FROM smartphone_whatsapp WHERE owner IN (SELECT phone FROM quantum_user_identities WHERE user_id = :user_id)'},
    { query = 'DELETE FROM quantum_user_identities WHERE user_id = :user_id'},
    { query = 'DELETE FROM quantum_homes WHERE user_id = :user_id'},
    { query = 'DELETE FROM box WHERE user_id = :user_id'},
    { query = 'DELETE FROM facs_user_goals WHERE user_id = :user_id'},
    { query = 'DELETE FROM facs_user_goals WHERE user_id = :user_id'},
    { query = 'DELETE FROM gamepass WHERE user_id = :user_id'},
    { query = 'DELETE FROM identity WHERE user_id = :user_id'},
    { query = 'DELETE FROM namoro WHERE user_id = :user_id OR relacionamentoCom = :user_id'},
    { query = 'DELETE FROM register WHERE user_id = :user_id'},
    { query = 'DELETE FROM reward WHERE user_id = :user_id'},
    -- { query = 'DELETE FROM quantum_banco WHERE user_id = :user_id'},
    -- { query = 'DELETE FROM core_killsystem WHERE user_id = :user_id'},
    { query = 'DELETE FROM quantum_user_groups WHERE user_id = :user_id'},
	{ query = 'DELETE FROM quantum_user_moneys WHERE user_id = :user_id'},
    { query = 'DELETE FROM quantum_user_data WHERE user_id = :user_id'},	
	{ query = 'DELETE FROM quantum_user_vehicles WHERE user_id = :user_id'},
    { query = 'DELETE FROM quantum_mdt WHERE user_id = :user_id'},
}

local reset_player = function(user_id)
	local _queries = queries
	for _id,_ in pairs(_queries) do
		_queries[_id].values = { ['user_id'] = user_id }
	end
	exports.oxmysql:transaction(_queries, function()
		quantum.resetIdentity(user_id)
	end)
end

AddEventHandler('quantum:playerLeave', function(user_id, source)
	local source = source
	if (resetList[source]) then
		print('RESETOU ('..user_id..')')
		reset_player(user_id)
	end
end)

RegisterCommand('resetply', function(source, args)
    local text = ''
    local user_id
	if (source ~= 0) then user_id = quantum.getUserId(source) end
	if (source == 0 or user_id) then
        if (source == 0 or quantum.hasPermission(user_id, '+Staff.COO')) then
            local nUser = tonumber(args[1])
            if (nUser <= 0) then return; end;

            local nIdentity = quantum.getUserIdentity(nUser)
            if (nIdentity) then
                if (source == 0) or quantum.request(source, 'Tem certeza em resetar o passaporte '..nUser..'?', 30000) then
                    local nSource = quantum.getUserSource(nUser)
                    if (nSource) then
                        resetList[nSource] = true
                        DropPlayer(nSource, 'Você foi resetado.')
                    else
                        reset_player(nUser)
                    end
                    if (source == 0) then
                        text = 'CONSOLE'
                        print('^5[AVISO]^7 Voce resetou o ID #^5'..nUser..'^7 ^5'..nIdentity.firstname..' '..nIdentity.lastname..'^7')
                    else
                        text = '#'..user_id..' '..identity.firstname..' '..identity.lastname
                        TriggerClientEvent('notify', source, 'Reset Player', 'Você resetou o passaporte <b>'..nUser..'</b>.')
                    end
                    quantum.webhook('ResetPlayer', '```prolog\n[/RESETPLAYER]\n[STAFF]: '..text..'\n[RESETADO]: '..nUser..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
                end
            else
                if (source ~= 0) then TriggerClientEvent('notify', source, 'Reset Player', 'Jogador <b>inexistente</b>.') end
            end
        end
    end
end)


---------------------------------------
-- ROUTING BUCKETS
---------------------------------------
RegisterCommand('getbucket', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        if (args[1]) then
            local nUser = parseInt(args[1])
            local nSource = quantum.getUserSource(nUser)
            if (nSource) and GetPlayerName(nSource) then
                TriggerClientEvent('notify', source, 'Get Bucket', 'O jogador <b>'..nUser..'</b> está na Sessão <b>'..GetPlayerRoutingBucket(nSource)..'</b>.', 8000)
            else
                TriggerClientEvent('notify', source, 'Get Bucket', 'O jogador <b>'..nUser..'</b> não foi encontrado.', 8000)
            end
        else
            TriggerClientEvent('notify', source, 'Get Bucket', 'Você está na Sessão <b>'..GetPlayerRoutingBucket(source)..'</b>.', 8000)
        end
    end
end)

RegisterCommand('setbucket', function(source, args)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) and quantum.hasPermission(user_id, '+Staff.Administrador') then
        if (args[1] and args[2]) then
            local nUser = parseInt(args[1])
            local nSource = quantum.getUserSource(nUser)
            local bucket = parseInt(args[2])
            if (nSource and GetPlayerName(nSource)) and (bucket >= 0) then
                SetPlayerRoutingBucket(nSource, bucket)
                TriggerClientEvent('notify', source, 'Set Bucket', 'O jogador <b>'..nUser..'</b> foi setado na sessão <b>'..bucket..'</b>.', 8000)
                quantum.webhook('Bucket', '```prolog\n[/SBUCKET]\n[STAFF]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[SETOU]: '..nUser..'\n[SESSÃO]: '..bucket..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            else
                TriggerClientEvent('notify', source, 'Set Bucket', 'O jogador <b>'..nUser..'</b> não foi encontrado.', 8000)
            end
        end
    end
end)


---------------------------------------
-- ID
---------------------------------------
RegisterCommand('identifier', function(source)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id,'+Staff.Administrador') then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            TriggerClientEvent('notify', nPlayer, 'Passaporte', 'O cidadão <b>'..user_id..'</b> está verificando o seu passaporte.')
            TriggerClientEvent('notify', source, 'Passaporte', 'Passaporte: <b>('..nUser..')</b>', 10000)
        end
    end
end)



---------------------------------------
-- RICH PRESENCE
---------------------------------------
AddEventHandler('quantum:playerSpawn', function(user_id, source)
    if (user_id) then
        local identity = quantum.getUserIdentity(user_id)
        if (identity) then
           TriggerClientEvent('quantum_core:discord', source, 'Jogando no New Valley - Season 1 !')
        end

        Citizen.SetTimeout(8000, function()
            local userTable = quantum.getUserDataTable(user_id)
            if (userTable) then
                if (userTable.Handcuff == true) then
                    Player(source).state.Handcuff = true
                    quantumClient.setHandcuffed(source, true)
                    TriggerClientEvent('quantum_interactions:algemas', source, 'colocar')
                end

                if (userTable.Capuz == true) then
                    Player(source).state.Capuz = true
                    quantumClient.setCapuz(source, true)
                end

                if (userTable.GPS == true) then
                    Player(source).state.GPS = true
                    TriggerClientEvent('quantum_system:gps', source)
                end
            end
        end)
    end
end)

RegisterNetEvent('quantum_system:gps_server', function()
    local source = source
    Player(source).state.GPS = false
end)

---------------------------------------
-- ROCKSTAR EDITOR
---------------------------------------
local rockstarCommands = {
    ['start'] = function(source)
        vCLIENT.StartEditor(source)
    end,
    ['save'] = function(source)
        vCLIENT.stopAndSave(source)
    end,
    ['discard'] = function(source)
        vCLIENT.Discard(source)
    end,
    ['open'] = function(source)
        vCLIENT.openEditor(source)
    end
}

RegisterCommand('rockstar', function(source, args) 
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'staff.permissao') then
        if (args[1]) and rockstarCommands[args[1]] then
            rockstarCommands[args[1]](source)
        else
            TriggerClientEvent('notify', source, 'Prefeitura', 'Você não <b>especificou</b> o que gostaria de utilizar, tente novamente:<br><br><b>- /rockstar start<br>- /rockstar save<br>- /rockstar open<br>- /rockstar discard</b>')
        end
    end
end)
---------------------------------------
-- DETIDO
---------------------------------------
-- RegisterCommand('detido', function(source)
--     local user_id = quantum.getUserId(source)
--     if (user_id) and quantum.checkPermissions(user_id, { 'staff.permissao', 'policia.permissao' }) then
--         local vehicle, vnetid = quantumClient.vehList(source, 5.0)
--         if (vnetid) then
--             local prompt = exports.quantum_hud:prompt(source, {
--                 'Motivo'
--             })

--             if (prompt) then
--                 prompt = prompt[1]

--                 local vehState = exports.quantum_garage:getVehicleData(vnetid)
--                 if (vehState.user_id) then
--                     local veh = quantum.query('quantum_dismantle/getVehicleInfo', { user_id = vehState.user_id, vehicle = vehState.model })[1]
--                     if (veh) then
--                         if (parseInt(veh.detained) > 0) then
--                             TriggerClientEvent('notify', source, 'Detido', 'Este <b>veículo</b> já se encontra detido.')
--                         else
--                             local nplayer = quantum.getUserSource(vehState.user_id)
--                             if (nplayer) then TriggerClientEvent('notify', nplayer, 'Detido', 'Seu veículo ('..quantum.vehicleName(vehState.model)..') foi <b>detido</b>.', 10000); end;

--                             quantumClient.playSound(source, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS')
--                             TriggerClientEvent('notify', source, 'Detido', 'O <b>veículo</b> foi apreendido com sucesso.')
--                             quantum.execute('quantum_garage/setDetained', { detained = 2, user_id = vehState.user_id, vehicle = vehState.model })
--                             quantum.webhook('Detido', '```prolog\n[/DETIDO]\n[OFFICER]: '..user_id..'\n[VEHICLE]: '..vehState.model..'\n[VEHICLE OWNER]: '..vehState.user_id..'\n[REASON]: '..prompt..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end)

---------------------------------------
-- TOOGLE
---------------------------------------
local _ToogleDefault = 'dndcwebhook/webhooks/1144388223624282143/9o-TWD0hG26CnVCynfmNsk8dJeoqsDsgSy7Kzq_7Ab7UJ6pufUVGztbu8TRJZYPhoId_'
local _ToogleStaff = 'dndcwebhook/webhooks/1144381802459447496/XE3lTagQ1PNW1e8_S8RVS2jBeKna_PCuvziPZKxwRxv7If8rru-HngXp1tuPAXzsIvAh'

local Toogle = {
    ['Policia'] = { 
        blip = { name = 'Policia', view = { ['Policia'] = true, ['Paramedico'] = true } },
        clearWeapons = true,
        webhook = 'dndcwebhook/webhooks/1144480658899619860/BZXGIS4sb1q9yagZJiMjkGauApmkPsIS_DcY0FiaLUZAa0oQPU6HG1xh0rVG61qARbPP',
        toggleCoords = {
            { coord = vector3(-2286.699, 356.0967, 174.5927), radius = 70 },
        }
    },
    ['Hospital'] = { 
        blip = { name = 'Paramedico', view = { ['Paramedico'] = true, ['Policia'] = true } },
        webhook = 'dndcwebhook/webhooks/1144480825119871086/vIH1P9fCuI_d8D6rv2E0w-KCJ0tQLGXh-2r8swqBVSX4vV3elJJuT80Y-WMcdWj7Xt4S',
        toggleCoords = {
            { coord = vector3(-816.1978, -1229.103, 7.324585), radius = 70 },
        }
    },
    ['Deic'] = { 
        blip = { name = 'DEIC', view = { ['Paramedico'] = true, ['Policia'] = true, ['Deic'] = true } },
        clearWeapons = true,
        webhook = 'dndcwebhook/webhooks/1141426122660261988/Qr_S_oy9DTpjdTPjeMAB7VRdmLtCnvzKnU09Js4sXW7gW9L_asrkqxA3K2C8wedVoUX1',
        toggleCoords = {
            { coord = vector3(480.5011, 4539.547, 79.96411), radius = 70 },
        }
    },
    ['quantumMecanica'] = { 
        -- webhook = 'dndcwebhook/webhooks/1141426122660261988/Qr_S_oy9DTpjdTPjeMAB7VRdmLtCnvzKnU09Js4sXW7gW9L_asrkqxA3K2C8wedVoUX1',
        toggleCoords = {
            { coord = vector3(138.1582, -3029.723, 7.02124), radius = 70 },
        }
    },
}

local getPoliceWeapons = {
    'weapon_pistol_mk2',
    'm_weapon_pistol_mk2',
    'weapon_combatpistol',
    'm_weapon_combatpistol',
    'weapon_smg_mk2',
    'm_weapon_smg_mk2',
    'weapon_combatpdw',
    'm_weapon_combatpdw',
    'weapon_assaultsmg',
    'm_weapon_assaultsmg',
    'weapon_pumpshotgun_mk2',
    'm_weapon_pumpshotgun_mk2',
    'weapon_combatshotgun',
    'm_weapon_combatshotgun',
    'weapon_carbinerifle_mk2',
    'm_weapon_carbinerifle_mk2',
    'weapon_militaryrifle',
    'm_weapon_militaryrifle',
    'weapon_tacticalrifle',
    'm_weapon_tacticalrifle',
    'weapon_sniperrifle',
    'm_weapon_sniperrifle',
    'weapon_nightstick',
    'weapon_stungun',
    'colete-militar'
}

local givePoliceWeapons = {
    ['weapon_combatpistol'] = 1,
    ['m_weapon_combatpistol'] = 50
}

-- RegisterCommand('toogle', function(source)
--     local user_id = quantum.getUserId(source)
--     local identity = quantum.getUserIdentity(user_id)
--     for k, v in pairs(Toogle) do
--         local inGroup, inGrade = quantum.hasGroup(user_id, k)
-- 		if (inGroup) then

--             local neartoggle = true	
-- 			if (v.toggleCoords) then
-- 				neartoggle = false
-- 				local coords = GetEntityCoords(GetPlayerPed(source))
-- 				for _, pos in pairs(v.toggleCoords) do
-- 					if #(pos.coord - coords) <= pos.radius then
-- 						neartoggle = true
-- 					end
--  				end
-- 			end

--             if (neartoggle) then
--                 local newState = (not quantum.hasGroupActive(user_id, k))
-- 				local groupName = quantum.getGroupTitle(k, inGrade)

--                 quantum.setGroupActive(user_id, k, newState)
--                 local logsmg = ''
-- 				if (newState) then
-- 					TriggerClientEvent('notify', source, 'Toogle', '<b>'..groupName..'</b> | Você entrou em serviço.')
-- 					logmsg = '[STATUS]: JOIN'
-- 					if (v.blip) then TriggerEvent("sw-blips:tracePlayer", source, v.blip.name, v.blip.view); end;
-- 				else
-- 					TriggerClientEvent('notify', source, 'Toogle', '<b>'..groupName..'</b> | Você saiu de serviço.')
-- 					logmsg = '[STATUS]: LEAVE'
-- 					if (v.blip) then TriggerEvent('sw-blips:unTracePlayer', source); end;
                    
--                     if (v.clearWeapons) then
--                         local weapons = quantumClient.replaceWeapons(source, {}, GlobalState.weaponToken)
--                         quantum.setKeyDataTable(user_id, 'weapons', {})

--                         for k, v in pairs(weapons) do
--                             local weapon = k:lower()
--                             quantum.giveInventoryItem(user_id, weapon, 1)
--                             if (v.ammo > 0) then
--                                 quantum.giveInventoryItem(user_id, 'm_'..weapon, v.ammo)
--                             end
--                         end

--                         for _, item in pairs(getPoliceWeapons) do
--                             local amount = quantum.getInventoryItemAmount(user_id, item)
--                             if (amount > 0) then
--                                 quantum.tryGetInventoryItem(user_id, item, amount)
--                                 TriggerClientEvent('notify', source, 'Toogle', 'Retiramos <b>'..math.floor(amount)..'x</b> de <b>'..quantum.itemNameList(item)..'</b> da sua mochila!')
--                             end
--                         end

--                         -- for item, amount in pairs(givePoliceWeapons) do
--                         --     quantum.giveInventoryItem(user_id, item, amount)
--                         --     TriggerClientEvent('notify', source, 'Toogle', 'Você recebeu <b>'..amount..'x</b> de <b>'..quantum.itemNameList(item)..'</b>')
--                         -- end                        
--                     end
--                 end

--                 quantum.webhook((v.webhook ~= '' and v.webhook or _ToogleDefault), '```prolog\n[/TOOGLE]\n[JOB]: '..string.upper(k)..' - '..string.upper(inGrade)..'\n[USER]: '..user_id..'# '..identity.firstname..' '..identity.lastname..'\n'..logmsg..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
--             else
--                 TriggerClientEvent('notify', source, 'Toogle', 'Você só pode usar <b>/toogle</b> nos locais de Trabalho!')
--             end
--         end	
--     end
-- end)

AddEventHandler('quantum:playerLeave', function(user_id, source)
    local identity = quantum.getUserIdentity(user_id)
	for k, v in pairs(Toogle) do
		local inGroup, inGrade = quantum.hasGroup(user_id,k)
		if (inGroup) and quantum.hasGroupActive(user_id,k) then		
			quantum.setGroupActive(user_id, k, false)
			quantum.webhook((v.webhook ~= '' and v.webhook or _ToogleDefault), '```prolog\n[/TOOGLE]\n[JOB]: '..string.upper(k)..' - '..string.upper(inGrade)..'\n[USER]: '..user_id..' '..identity.firstname..' '..identity.lastname..'\n[STATUS]: LEAVE'..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
		end
	end
end)

-- local prefeituraCoord = vector3(-550.9846, -193.2, 38.21021)
-- RegisterCommand('staff',function(source)
-- 	local user_id = quantum.getUserId(source)
--     local identity = quantum.getUserIdentity(user_id)
-- 	local groupName, groupInfo = quantum.getUserGroupByType(user_id, 'staff')
--     if (groupName) then
--         if (#(GetEntityCoords(GetPlayerPed(source)) - prefeituraCoord) <= 50) then
--             quantum.setGroupActive(user_id, groupName, (not groupInfo.active))

--             local logmsg = ''
--             if (not groupInfo.active) then
--                 TriggerClientEvent('notify', source, 'Toogle', '<b>'..groupName..'</b> | Você entrou em serviço.')	
--                 logmsg = '[STATUS]: JOIN'
--             else
--                 TriggerClientEvent('notify', source, 'Toogle', '<b>'..groupName..'</b> | Você saiu de serviço.')
--                 logmsg = '[STATUS]: LEAVE'
--             end

--             quantum.webhook(_ToogleStaff, '```prolog\n[/STAFF]\n[JOB]: '..string.upper(groupName)..'\n[USER]: '..user_id..' '..identity.firstname..' '..identity.lastname..'\n'..logmsg..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
--         else
--             TriggerClientEvent('notify', source, 'Toogle', 'Você não está na <b>prefeitura</b>!')
--         end   
--     end
-- end)

---------------------------------------
-- PTR
---------------------------------------
-- RegisterCommand('ptr', function(source)
--     local user_id = quantum.getUserId(source)
--     if (user_id) then
--         local count = 0
--         local name = ''
--         for k, v in pairs(quantum.getUsersByPermission('policia.permissao')) do
--             local identity = quantum.getUserIdentity(v)
--             if (identity) then
--                 name = name..'<b>'..v..'</b>: '..identity.firstname..' '..identity.lastname.. '<br>'
--             end
--             count = (count + 1)
--         end

--         TriggerClientEvent('notify', source, 'Prefeitura', 'Atualmente <b>'..count..' Oficiais</b> em serviço.')
--         if (quantum.checkPermissions(user_id, { 'staff.permissao', 'policia.permissao' }) and count > 0) then
--             TriggerClientEvent('notify', source, 'Prefeitura', name)
--         end
--     end
-- end)

---------------------------------------
-- EMS
-- ---------------------------------------
-- RegisterCommand('ems', function(source)
--     local user_id = quantum.getUserId(source)
--     if (user_id) then
--         local count = 0
--         local name = ''
--         for k, v in pairs(quantum.getUsersByPermission('hospital.permissao')) do
--             local identity = quantum.getUserIdentity(v)
--             if (identity) then
--                 name = name..'<b>'..v..'</b>: '..identity.firstname..' '..identity.lastname.. '<br>'
--             end
--             count = (count + 1)
--         end

--         TriggerClientEvent('notify', source, 'Prefeitura', 'Atualmente <b>'..count..' Paramédicos</b> em serviço.')
--         if (quantum.checkPermissions(user_id, { 'staff.permissao', 'hospital.permissao' }) and count > 0) then
--             TriggerClientEvent('notify', source, 'Prefeitura', name)
--         end
--     end
-- end)

---------------------------------------
-- STATUS
-- ---------------------------------------
-- RegisterCommand('status', function(source)
--     local user_id = quantum.getUserId(source)
--     if (user_id) then
--         local onlinePlayers = GetNumPlayerIndices()
--         local staff = quantum.getUsersByPermission('staff.permissao')
--         local policias = quantum.getUsersByPermission('policia.permissao')
--         local ems = quantum.getUsersByPermission('hospital.permissao')
--         local mec = quantum.getUsersByPermission('quantummecanica.permissao')
--         local fome = quantum.getUsersByPermission('quantumfome.permissao')
        
--         TriggerClientEvent('notify', source, 'Prefeitura', 'Status dos serviços da nossa cidade: <br> <br> <b>Prefeitura</b>: '..#staff..' <br> <b>Policia</b>: '..#policias..' <br> <b>Paramédico</b>: '..#ems..' <br> <b>Mecânico</b>: '..#mec..' <br> <b>quantum Fome</b>: '..#fome..' <br> <b>Cidadãos</b>: '..onlinePlayers)
--     end
-- end)

---------------------------------------
-- ADMON
---------------------------------------
-- RegisterCommand('admon', function(source)
--     local user_id = quantum.getUserId(source)
--     if (user_id and quantum.checkPermissions(user_id, { '+Staff.Manager' })) then
--         local count = 0
--         local name = ''
--         for k, v in pairs(quantum.getUsersByPermission('staff.permissao')) do
--             local identity = quantum.getUserIdentity(v)
--             if (identity) then
--                 name = name..'<b>'..v..'</b>: '..identity.firstname..' '..identity.lastname.. '<br>'
--             end
--             count = (count + 1)
--         end

--         TriggerClientEvent('notify', source, 'Prefeitura', 'Atualmente <b>'..count..' Staffs</b> em serviço.')
--         if (count > 0) then
--             TriggerClientEvent('notify', source, 'Prefeitura', name)
--         end
--     end
-- end)

---------------------------------------
-- SEQUESTRO
---------------------------------------
RegisterCommand('sequestro', function(source)
    local nPlayer = quantumClient.getNearestPlayer(source, 5)
	if (nPlayer) then
        if (vCLIENT.checkSequestro(source) == -1) then TriggerClientEvent('notify', source, 'Sequestro', 'Este <b>veículo</b> não tem porta-malas.') return; end;
        if (GetEntityHealth(GetPlayerPed(source)) <= 100) then return; end;
        if (quantumClient.isHandcuffed(source)) then return; end;
		if (quantumClient.isHandcuffed(nPlayer)) then
			if (not quantumClient.getNoCarro(source)) then
				local vehicle = quantumClient.getNearestVehicle(source,7)
				if (vehicle) then
                    
					if quantumClient.getCarroClass(source,vehicle) then
						quantumClient.setMalas(nPlayer)
					end
				end
			elseif (quantumClient.isMalas(nPlayer)) then
				quantumClient.setMalas(nPlayer)
			end
		else
			TriggerClientEvent('notify', source, 'Sequestro', 'A pessoa precisa estar algemada para colocar ou retirar do <b>porta-malas</b>.')
		end
	end
end)

---------------------------------------
-- APREENDER
---------------------------------------
local apreenderWebhook = 'dndcwebhook/webhooks/1147703583047958568/1ue7-nqHnORbJOaBXKfbRr0E8m81Q3F3HXbCJg7hvJPYHrO9Oxn0ldEJwALJ0kGnkPAq'

RegisterCommand('apreender', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.checkPermissions(user_id, { 'policia.permissao', 'staff.permissao' }) then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100 or quantumClient.isHandcuffed(nPlayer)) then
                if (GetEntityHealth(GetPlayerPed(source)) <= 100) then return end;
                local nUser = quantum.getUserId(nPlayer)
                if (nUser) then
                    local nIdentity = quantum.getUserIdentity(nUser)
                    local request = exports.quantum_hud:request(source, 'Você tem certeza que deseja apreender os itens ilegais do '..nIdentity.firstname..' '..nIdentity.lastname..'?', 30000)
                    if (request) then
                        local itens = {}
                        local weapons = quantumClient.replaceWeapons(nPlayer, {}, GlobalState.weaponToken)
                        quantum.setKeyDataTable(nUser, 'weapons', {})
                        
                        for k, v in pairs(weapons) do
                            local weapon = k:lower()
                            quantum.giveInventoryItem(nUser, weapon, 1)
                            if (v.ammo > 0) then
                                quantum.giveInventoryItem(nUser, 'm_'..weapon, v.ammo)
                            end
                        end
                        
                        quantumClient._playAnim(source, true, {
                            { 'oddjobs@shop_robbery@rob_till', 'loop' }
                        }, true)
                        TriggerClientEvent('progressBar', source, 'Apreendendo...', 5000)
                        Wait(5000)
                        local inventory = quantum.getInventory(nUser)
                        for k, v in pairs(inventory) do
                            local itemConfig = exports.quantum_inventory:getItemInfo(k)
                            if (itemConfig.arrest) then
                                if (quantum.tryGetInventoryItem(nUser, k, v.amount)) then
                                    table.insert(itens, v.amount..'x '..(quantum.itemNameList(k) or k))		
                                end
                            end
                        end
                        local ped = GetPlayerPed(source)
                        ClearPedTasks(ped)

                        TriggerClientEvent('notify', nPlayer, 'Apreensão', 'Todos os seus itens ilegais foram <b>apreendidos</b> e enviados à prefeitura!')
                        TriggerClientEvent('notify', source, 'Apreensão', 'Você <b>apreendeu</b> todos os itens ilegais do cidadão!')
                        TriggerClientEvent('radio:outServers', nPlayer)
                        
                        quantum.webhook(apreenderWebhook, '```prolog\n[APREENSÃO]\n[OFFICER]: '..user_id..'\n[TARGET]: '..nUser..'\n[ITENS]: '..json.encode(itens, { indent = true })..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                    end
                end
            else
                TriggerClientEvent('notify', source, 'Apreensão', 'O cidadão precisa estar <b>algemado</b> ou <b>desmaiado</b>!');
            end
        end
    end
end)