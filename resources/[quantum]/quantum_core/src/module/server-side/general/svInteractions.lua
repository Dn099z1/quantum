RegisterNetEvent('quantum_interactions:putHandcuff', function()
    local source = source
    local user_id = quantum.getUserId(source)
    local item = quantum.getInventoryItemAmount(user_id, 'algema')

    if user_id and item and item > 0 then
        if quantumClient.isHandcuffed(source) then return end

        if GetSelectedPedWeapon(GetPlayerPed(source)) ~= GetHashKey('WEAPON_UNARMED') then
            TriggerClientEvent('notify', source, 'Interação Algemar', 'Sua <b>mão</b> está ocupada.')
            return
        end

        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if nPlayer then
            if GetEntityHealth(GetPlayerPed(source)) <= 100 or GetEntityHealth(GetPlayerPed(nPlayer)) <= 100 then return end

            quantum.tryGetInventoryItem(user_id, 'algema', 1)
            quantum.giveInventoryItem(user_id, 'chave-algema', 1)

            TriggerClientEvent('quantum:attach', nPlayer, source, 4103, 0.0, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, 2, true)

            Player(source).state.BlockTasks = true
            Player(nPlayer).state.BlockTasks = true

            quantumClient.playAnim(source, false, {
                { 'mp_arrest_paired', 'cop_p2_back_left' }
            }, false)

            quantumClient.playAnim(nPlayer, false, {
                { 'mp_arrest_paired', 'crook_p2_back_left' }
            }, false)

            Citizen.SetTimeout(3500, function()
                TriggerClientEvent('quantum:attach', nPlayer, source)

                Player(source).state.BlockTasks = false
                Player(nPlayer).state.BlockTasks = false

                ClearPedTasks(GetPlayerPed(nPlayer))
                ClearPedTasks(GetPlayerPed(source))

                Player(nPlayer).state.Handcuff = true
                quantumClient.setHandcuffed(nPlayer, true)

                TriggerClientEvent('quantum_sound:source', source, 'cuff', 0.1)
                TriggerClientEvent('quantum_sound:source', nPlayer, 'cuff', 0.1)
                TriggerClientEvent('quantum_interactions:algemas', nPlayer, 'colocar')
            end)
        end
    else
        TriggerClientEvent('notify', source, 'Interação Algemar', 'Você não possui uma <b>algema</b>.')
    end
end)


RegisterNetEvent('quantum_interactions:removeHandcuff', function()
    local source = source
    local user_id = quantum.getUserId(source)

    if user_id then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if nPlayer and quantumClient.isHandcuffed(nPlayer) then
            if quantum.tryGetInventoryItem(user_id, 'chave-algema', 1) then
                TriggerClientEvent('quantum:attach', nPlayer, source, 4103, 0.1, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, 2, true)

                Player(source).state.BlockTasks = true
                Player(nPlayer).state.BlockTasks = true

                quantumClient.playAnim(source, false, {
                    { 'mp_arresting', 'a_uncuff' }
                }, false)

                quantumClient.playAnim(nPlayer, false, {
                    { 'mp_arresting', 'b_uncuff' }
                }, false)

                Citizen.SetTimeout(5000, function()
                    TriggerClientEvent('quantum:attach', nPlayer, source)

                    Player(source).state.BlockTasks = false
                    Player(nPlayer).state.BlockTasks = false

                    ClearPedTasks(GetPlayerPed(nPlayer))
                    ClearPedTasks(GetPlayerPed(source))

                    Player(nPlayer).state.Handcuff = false
                    quantumClient.setHandcuffed(nPlayer, false)

                    TriggerClientEvent('quantum_sound:source', source, 'uncuff', 0.1)
                    TriggerClientEvent('quantum_sound:source', nPlayer, 'uncuff', 0.1)
                    TriggerClientEvent('quantum_interactions:algemas', nPlayer)
                end)
            else
                TriggerClientEvent('notify', source, 'Interação Algemar', 'Você não possui uma <b>chave de algema</b>.')
            end
        else
            TriggerClientEvent('notify', source, 'Interação Algemar', 'Nenhum jogador algemado encontrado por perto.')
        end
    end
end)



RegisterNetEvent('quantum_interactions:colocarCapuz', function()
    TriggerEvent('quantum_interactions:capuz','colocar')
end)

RegisterNetEvent('quantum_interactions:retirarCapuz', function()
    TriggerEvent('quantum_interactions:capuz','retirar')
end)

RegisterNetEvent('quantum_interactions:capuz', function(value)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        if (value == 'colocar') then
            if (quantumClient.getNoCarro(source)) then return; end;
            if (quantumClient.isHandcuffed(source)) then return; end;
            if (GetSelectedPedWeapon(GetPlayerPed(source)) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Interação Algemar', 'Sua <b>mão</b> está ocupada.') return; end;

            local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
            if (nPlayer) then
                local cooldown = 'capuz:'..nPlayer
                if (exports.quantum_core:GetCooldown(cooldown)) then
                    TriggerClientEvent('notify', source, 'Interação Capuz', 'Aguarde <b>'..exports.quantum_core:GetCooldown(cooldown)..' segundos</b> para encapuzar novamente.')
                    return
                end
                exports.quantum_core:CreateCooldown(cooldown, 10)

                if (quantumClient.getNoCarro(nPlayer)) then return; end;
                if (not quantumClient.isHandcuffed(nPlayer)) then TriggerClientEvent('notify', source, 'Interação Capuz', 'Você não pode <b>encapuzar</b> uma pessoa desalgemada.') return; end;
                if (quantumClient.isCapuz(nPlayer)) then TriggerClientEvent('notify', source, 'Interação Capuz', 'O mesmo já está <b>encapuzado</b>.') return; end;
                
                if (not quantum.tryGetInventoryItem(user_id, 'capuz', 1)) then TriggerClientEvent('notify', source, 'Interação Capuz', 'Você não possui um <b>capuz</b> em seu inventário.') return; end;

                Player(nPlayer).state.Capuz = true
                quantumClient.setCapuz(nPlayer, true)
            end
        else
            if (quantumClient.getNoCarro(source)) then return; end;
            if (GetSelectedPedWeapon(GetPlayerPed(source)) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Interação Algemar', 'Sua <b>mão</b> está ocupada.') return; end;
            
            local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
            if (nPlayer) then
                if (quantumClient.getNoCarro(nPlayer)) then return; end;
                if (not quantumClient.isCapuz(nPlayer)) then TriggerClientEvent('notify', source, 'Interação Capuz', 'O mesmo não está <b>encapuzado</b>') return; end;

                Player(nPlayer).state.Capuz = false
                quantumClient.setCapuz(nPlayer, false)
                quantum.giveInventoryItem(user_id, 'capuz', 1)
            end
        end
    end
end)

quantum.prepare('quantum_relationship/getUser', 'select * from relationship where user_1 = @user')
quantum.prepare('quantum_relationship/updateRelation', 'update relationship set relation = @relation where user_1 = @user')
quantum.prepare('quantum_relationship/createRelation', 'insert into relationship (user_1, user_2, relation, start_relationship) values (@user_1, @user_2, @relation, @start_relationship)')
quantum.prepare('quantum_relationship/deleteRelation', 'delete from relationship where user_1 = @user')

local CheckUser = function(user_id)
    local query = quantum.query('quantum_relationship/getUser', { user = user_id })[1]
    if (query) then
        return true, query.user_2, query.relation, query.start_relationship
    end
    return false
end
exports('CheckUser', CheckUser)

RegisterNetEvent('quantum_interactions:relacionamento', function()
    local source = source
    local user_id = quantum.getUserId(source)
	if (user_id) then
        local relation, couple, status, date = CheckUser(user_id)
        if (not relation) then TriggerClientEvent('notify', source, 'Checar relacionamento', 'Você não está em um <b>relacionamento</b> 🤣.') return; end;

        local nIdentity = quantum.getUserIdentity(couple)
        TriggerClientEvent('notify', source, 'Checar relacionamento', 'Informações do seu relacionamento: <br><br>- Você está: <b>'..status..'</b><br>- Cônjugue: <b>'..nIdentity.firstname..' '..nIdentity.lastname..'</b><br>- Início do seu relacionamento: ( <b>'..os.date('\n%d/%m/%Y', tonumber(date))..'</b> )', 10000)
    end
end)

RegisterNetEvent('quantum_interactions:noivar', function()
    local source = source
    local user_id = quantum.getUserId(source)
	if (user_id) then
        local relation, couple, status = CheckUser(user_id)
        if (not relation) then TriggerClientEvent('notify', source, 'Pedido de casamento', 'Você não está em um <b>relacionamento</b> 🤣.') return; end;
        if (status == 'Noivo(a)') then TriggerClientEvent('notify', source, 'Pedido de casamento', 'Você já está <b>noivado(a)</b> criatura.') return; end;

        local identity = quantum.getUserIdentity(user_id)
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            if (couple ~= nUser) then TriggerClientEvent('notify', source, 'Pedido de casamento', 'Você não é <b>namorado(a)</b> desta pessoa talarico(a).') return; end;
            if (nUser) then
                local nIdentity = quantum.getUserIdentity(nUser)
                if (quantum.request(source, 'Você gostaria de pedir o(a) '..nIdentity.firstname..' '..nIdentity.lastname..' em casamento?', 30000)) then
                    if (quantum.request(nPlayer, 'Você gostaria de aceitar o pedido de casamento de '..identity.firstname..' '..identity.lastname..'?', 30000)) then
                        TriggerClientEvent('notify', nPlayer, 'Pedido de casamento', 'Parabéns aos pombinhos! Agora vocês são <b>noivos</b>.')
                        TriggerClientEvent('notify', source, 'Pedido de casamento', 'Parabéns aos pombinhos! Agora vocês são <b>noivos</b>.')

                        quantum.execute('quantum_relationship/updateRelation', { user = user_id, relation = 'Noivo(a)' })
                        quantum.execute('quantum_relationship/updateRelation', { user = nUser, relation = 'Noivo(a)' })

                        quantum.webhook('Noivar', '```prolog\n[RELATION SHIP]\n[ACTION]: (MARRIAGE PROPOSAL)\n[USER]: '..user_id..'\n[TARGET]: '..nUser..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                    else
                        TriggerClientEvent('notify', source, 'Pedido de casamento', 'O seu pedido de <b>casamento</b> foi negado.')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:namorar', function()
    local source = source
    local user_id = quantum.getUserId(source)
	if (user_id) then
        if (CheckUser(user_id)) then TriggerClientEvent('notify', source, 'Pedido de namoro', 'Você já está <b>namorando</b> sapeca.') return; end;
        local identity = quantum.getUserIdentity(user_id)
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            if (CheckUser(nUser)) then TriggerClientEvent('notify', source, 'Pedido de namoro', 'Está pessoa já está <b>namorando</b> talarico(a).') return; end;
            if (nUser) then
                local nIdentity = quantum.getUserIdentity(nUser)
                if (quantum.request(source, 'Você gostaria de pedir o(a) '..nIdentity.firstname..' '..nIdentity.lastname..' em namoro?', 30000)) then
                    if (quantum.request(nPlayer, 'Você gostaria de aceitar o pedido de namoro de '..identity.firstname..' '..identity.lastname..'?', 30000)) then
                        TriggerClientEvent('notify', nPlayer, 'Pedido de namoro', 'Parabéns aos pombinhos! Agora vocês estão <b>namorando</b>.')
                        TriggerClientEvent('notify', source, 'Pedido de namoro', 'Parabéns aos pombinhos! Agora vocês estão <b>namorando</b>.')

                        quantum.execute('quantum_relationship/createRelation', { user_1 = user_id, user_2 = nUser, relation = 'Namorando', start_relationship = os.time() })
                        quantum.execute('quantum_relationship/createRelation', { user_1 = nUser, user_2 = user_id, relation = 'Namorando', start_relationship = os.time() })

                        quantum.webhook('Namorar', '```prolog\n[RELATION SHIP]\n[ACTION]: (START RELATION)\n[USER]: '..user_id..'\n[TARGET]: '..nUser..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                    else
                        TriggerClientEvent('notify', source, 'Pedido de namoro', 'O seu pedido de <b>namoro</b> foi negado.')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:terminar', function()
    local source = source
    local user_id = quantum.getUserId(source)
	if (user_id) then
        local relation, couple, status = CheckUser(user_id)
        if (not relation) then TriggerClientEvent('notify', source, 'Terminar relacionamento', 'Você não está em um <b>relacionamento</b> 🤣.') return; end;

        local text = (status == 'Namorando' and 'namoro' or 'noivado')
        local identity = quantum.getUserIdentity(couple)
        if (quantum.request(source, 'Você tem certeza que deseja terminar o seu '..text..' com o(a) '..identity.firstname..' '..identity.lastname..'?', 30000)) then
            TriggerClientEvent('notify', source, 'Terminar relacionamento', 'Parabéns parceiro(a)! Agora você está na <b>pista</b>.')
            if (quantum.getUserSource(couple)) then TriggerClientEvent('notify', quantum.getUserSource(couple), 'Terminar relacionamento', 'Parabéns parceiro(a)! Agora você está na <b>pista</b>.'); end;

            quantum.execute('quantum_relationship/deleteRelation', { user = user_id })
            quantum.execute('quantum_relationship/deleteRelation', { user = couple })

            quantum.webhook('Terminar', '```prolog\n[RELATION SHIP]\n[ACTION]: (STOP RELATION)\n[USER]: '..user_id..'\n[TARGET]: '..couple..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
        end
    end
end)

RegisterNetEvent('quantum_interactions:carregar', function()
    local source = source
    local user_id = quantum.getUserId(source)
    local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
    if (user_id) and nPlayer then
        if (quantum.hasPermission(user_id, 'staff.permissao') or quantum.hasPermission(user_id, 'polpar.permissao')) then
            if (not quantumClient.isHandcuffed(source)) then
                TriggerClientEvent('carregar', nPlayer, source)
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:vestimenta', function(value)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (user_id) and quantum.hasPermission(user_id, 'polpar.permissao') then
        local nplayer = quantumClient.getNearestPlayer(source, 2)
        if (nplayer) then
            local nUser = quantum.getUserId(nplayer)
            local nidentity = quantum.getUserIdentity(nUser)
            if (value == 'rmascara') then
                TriggerClientEvent('quantum_commands_police:clothes', nplayer, 'rmascara')
                quantum.webhook('PoliceCommands', '```prolog\n[/RMASCARA]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[RETIROU A MASCARA DO]\n[JOGADOR]: #'..nUser..' '..nidentity.firstname..' '..nidentity.lastname..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            elseif (value == 'rchapeu') then
                TriggerClientEvent('quantum_commands_police:clothes', nplayer, 'rchapeu')
			    quantum.webhook('PoliceCommands', '```prolog\n[/RCHAPEU]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[RETIROU O CHAPEU DO]\n[JOGADOR]: #'..nUser..' '..nidentity.firstname..' '..nidentity.lastname..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
            end
        else
            TriggerClientEvent('notify', source, 'Interação Policia', 'Você não se encontra próximo de um <b>cidadão</b>.')
        end
	end
end)

RegisterNetEvent('quantum_interactions:acessorios', function(value)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (user_id) and quantum.hasPermission(user_id, 'polpar.permissao') then
        local coord = GetEntityCoords(GetPlayerPed(source))
        if (value == 'cone') then
            if (not quantum.tryGetInventoryItem(user_id, 'cone', 1)) then
                TriggerClientEvent('notify', source, 'Inventário', 'Você não possui um <b>cone</b> em sua mochila!')
                return
            end
            TriggerClientEvent('cone', source)
            quantum.webhook('PoliceCommands', '```prolog\n[/CONE]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[CRIOU UM CONE NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        elseif (value == 'coned') then
            TriggerClientEvent('cone', source, 'd')
            quantum.webhook('PoliceCommands', '```prolog\n[/CONE]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[DELETOU UM CONE NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        elseif (value == 'barreira') then
            if (not quantum.tryGetInventoryItem(user_id, 'barreira', 1)) then
                TriggerClientEvent('notify', source, 'Inventário', 'Você não possui uma <b>barreira</b> em sua mochila!')
                return
            end
            TriggerClientEvent('barreira', source)
		    quantum.webhook('PoliceCommands', '```prolog\n[/BARREIRA]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[CRIOU UMA BARREIRA NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        elseif (value == 'barreirad') then
            TriggerClientEvent('barreira', source, 'd')
		    quantum.webhook('PoliceCommands', '```prolog\n[/BARREIRA]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[DELETOU UMA BARREIRA NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        elseif (value == 'spike') then
            if (not quantum.tryGetInventoryItem(user_id, 'spike', 1)) then
                TriggerClientEvent('notify', source, 'Inventário', 'Você não possui uma <b>spike</b> em sua mochila!')
                return
            end
            TriggerClientEvent('spike', source)
		    quantum.webhook('PoliceCommands', '```prolog\n[/SPIKE]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[CRIOU UMA SPIKE NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        elseif (value == 'spiked') then
            TriggerClientEvent('spike', source, 'd')
		    quantum.webhook('PoliceCommands', '```prolog\n[/SPIKE]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[DELETOU UMA SPIKE NA]\n[COORDENADA]: '..tostring(coord)..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        end        
    end
end)

RegisterNetEvent('quantum_interactions:cv', function()
    local source = source
	local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (quantum.hasPermission(user_id, 'polpar.permissao')) then
        if (quantumClient.isInVehicle(source)) then
            TriggerClientEvent('notify', source, 'Colocar no veículo', 'Você não pode utilizar este comando de dentro de um <b>veículo</b>.')
            return
        end

		local nplayer = quantumClient.getNearestPlayer(source, 2.0)
		if (nplayer) then
			local nUser = quantum.getUserId(nplayer)
			local nIdentity = quantum.getUserIdentity(nUser)
            quantumClient.putInNearestVehicleAsPassenger(nplayer, 5)
			quantum.webhook('PoliceCommands', '```prolog\n[/CV]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[DEU CV NO]\n[JOGADOR]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        else
            TriggerClientEvent('notify', source, 'Colocar Veículo', 'Você não se encontra próximo de um <b>cidadão</b>.')
        end
	end
end)

RegisterNetEvent('quantum_interactions:rv', function()
    local source = source
	local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
	if (quantum.hasPermission(user_id, 'polpar.permissao')) then
        if (quantumClient.isInVehicle(source)) then
            TriggerClientEvent('notify', source, 'Retirar do veículo', 'Você não pode utilizar este comando de dentro de um <b>veículo</b>.')
            return
        end

		local nplayer = quantumClient.getNearestPlayer(source, 2.0)
		if (nplayer) then
			local nUser = quantum.getUserId(nplayer)
			local nIdentity = quantum.getUserIdentity(nUser)
            quantumClient.ejectVehicle(nplayer)
			quantum.webhook('PoliceCommands', '```prolog\n[/RV]\n[USER_ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..'\n[DEU RV NO]\n[JOGADOR]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..' '..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
        else
            TriggerClientEvent('notify', source, 'Retirar Veículo', 'Você não se encontra próximo de um <b>cidadão</b>.')
        end
	end
end)

RegisterNetEvent('quantum_interactions:tow', function()
    local source = source
	local user_id = quantum.getUserId(source)
	if (user_id) and quantum.hasPermission(user_id, 'quantummecanica.permissao') then
        if (Player(source).state.Handcuff) then return; end;
		TriggerClientEvent('vTow', source)
	end
end)

RegisterNetEvent('quantum_interactions:enviar', function()
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id) then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            local nIdentity = quantum.getUserIdentity(nUser)
            local amount = quantum.prompt(source, { 'Quantidade de dinheiro' })
            if (amount) then
                amount = parseInt(amount[1])
                if (quantum.tryPayment(user_id, amount)) then
                    quantum.giveMoney(nUser, amount)
                    --exports.qbank:extrato(user_id, 'Transferência', -amount)
                    --exports.qbank:extrato(nUser, 'Transferência', amount)
                    quantumClient._playAnim(source, true, {{ 'mp_common', 'givetake1_a' }}, false)
			        quantumClient._playAnim(nPlayer, true, {{ 'mp_common', 'givetake1_a' }}, false)
                    TriggerClientEvent('notify', source, 'Interação Enviar', 'Você enviou <b>R$'..quantum.format(amount)..'</b>.')
                    TriggerClientEvent('notify', nPlayer, 'Interação Enviar', 'Você recebeu <b>R$'..quantum.format(amount)..'</b>.')
                    quantum.webhook('Enviar', '```prolog\n[/ENVIAR]\n[ID]: #'..user_id..' '..identity.firstname..' '..identity.lastname..' \n[ENVIOU]: R$'..quantum.format(amount)..' \n[PARA O ID]: #'..nUser..' '..nIdentity.firstname..' '..nIdentity.lastname..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..' \r```')
                else
                    TriggerClientEvent('notify', source, 'Interação Enviar', 'Você não possui essa quantia de <b>dinheiro</b> em mãos.')
                end
            end
        else
            TriggerClientEvent('notify', source, 'Interação Enviar', 'Você não se encontra próximo de um <b>cidadão</b>.')
        end
    end
end)

RegisterNetEvent('quantum_interactions:homesAdd', function()
    local source = source    
    exports['quantum_homes']:homesAdd(source)
end)

RegisterNetEvent('quantum_interactions:homesRem', function()
    local source = source    
    exports['quantum_homes']:homesRem(source)
end)

RegisterNetEvent('quantum_interactions:homesTrans', function()
    local source = source    
    exports['quantum_homes']:homesTrans(source)
end)

RegisterNetEvent('quantum_interactions:homesVender', function()
    local source = source    
    exports['quantum_homes']:homesVender(source)
end)

RegisterNetEvent('quantum_interactions:homesChecar', function()
    local source = source    
    exports['quantum_homes']:homesChecar(source)
end)

RegisterNetEvent('quantum_interactions:homesTax', function()
    local source = source    
    exports['quantum_homes']:homesTax(source)
end)

RegisterNetEvent('quantum_interactions:homesOther', function()
    local source = source    
    exports['quantum_homes']:homesOther(source)
end)

RegisterNetEvent('quantum_interactions:homesTrancar', function()
    local source = source    
    exports['quantum_homes']:homesTrancar(source)
end)

RegisterNetEvent('quantum_interactions:homesInterior', function(value)
    local source = source    
    if (value ~= '') then exports['quantum_homes']:updateInterior(source, value);
    else exports['quantum_homes']:homesInterior(source); end;
end)

RegisterNetEvent('quantum_interactions:homesDecoration', function(value)
    local source = source    
    if (value ~= '') then exports['quantum_homes']:updateDecoration(source, value);
    else exports['quantum_homes']:homesDecoration(source); end;
end)

RegisterNetEvent('quantum_interactions:homesBau', function(value)
    local source = source    
    exports['quantum_homes']:homesBau(source)
end)

RegisterNetEvent('quantum_interactions:homesGaragem', function(value)
    local source = source    
    exports['quantum_homes']:homesGaragem(source)
end)

RegisterNetEvent('quantum_interactions:homesLacrar', function(value)
    local source = source    
    exports['quantum_homes']:homesLacrar(source)
end)

local porte = 'dndcwebhook/webhooks/1151322402219892776/7kxoXel96Cn-Ns3CyQzFsitXR8dcmt7CnTt9nWtrTfmmhEHAR-bbqxJhY3TgxD-2Vqf_'

RegisterNetEvent('quantum_interactions:porte', function()
    local source = source
    local user_id = quantum.getUserId(source)

    local prompt = exports.quantum_hud:prompt(source, {
        'Nome do Personagem', 'Passaporte do Jogador', 'Número de Telefone', 'Motivo para Pedido de Reabilitação criminal: (Por favor, forneça uma explicação detalhada do motivo pelo qual seu personagem precisa de Reabilitação criminal).', 'Informações Adicionais: (Qualquer informação adicional que você deseja fornecer para justificar o pedido de Reabilitação criminal).'
    })
    if (not prompt) then TriggerClientEvent('notify', source, 'Porte de Arma', 'Você precisa preencher o <b>formulário</b>.') return; end;

    exports.quantum:webhook(porte, '```prolog\n[PEDIDO - PORTE DE ARMAS]\n[ADVOGADO]: '..user_id..'\n[NOME DO PERSONAGEM]: '..prompt[1]..'\n[PASSAPORTE DO JOGADOR]: '..prompt[2]..'\n[NÚMERO DE TELEFONE]: '..prompt[3]..'\n[MOTIVO]: '..prompt[4]..'\n[INFORMAÇÕES ADICIONAIS]: '..prompt[5]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\n```')
end)

local ficha = 'dndcwebhook/webhooks/1151349939306254406/o6zL8ujCeQE-E9z3Oe9GgZogx28hqo1pp0S04voaG7ICtwWJSpxYJ1r_j9NMOUppLdy-'

RegisterNetEvent('quantum_interactions:fichasuja', function()
    local source = source
    local user_id = quantum.getUserId(source)

    local prompt = exports.quantum_hud:prompt(source, {
        'Nome do Personagem', 'Passaporte do Jogador', 'Número de Telefone', 'Motivo para Pedido de Reabilitação criminal: (Por favor, forneça uma explicação detalhada do motivo pelo qual seu personagem precisa de Reabilitação criminal).', 'Informações Adicionais: (Qualquer informação adicional que você deseja fornecer para justificar o pedido de Reabilitação criminal).'
    })
    if (not prompt) then TriggerClientEvent('notify', source, 'Porte de Arma', 'Você precisa preencher o <b>formulário</b>.') return; end;

    exports.quantum:webhook(ficha, '```prolog\n[PEDIDO - LIMPAR A FICHA]\n[ADVOGADO]: '..user_id..'\n[NOME DO PERSONAGEM]: '..prompt[1]..'\n[PASSAPORTE DO JOGADOR]: '..prompt[2]..'\n[NÚMERO DE TELEFONE]: '..prompt[3]..'\n[MOTIVO]: '..prompt[4]..'\n[INFORMAÇÕES ADICIONAIS]: '..prompt[5]..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\n```')
end)

local Perimetros = {}
local perimetroWebhook = 'dndcwebhook/webhooks/1151693759214538846/50j3tshQN2SDvGOxilBoxDefNnwIAxMND58P8KwId4b3pQqP65K1OEPDNjNHx09364bF'

RegisterNetEvent('quantum_interactions:fecharperimetro', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'policia.permissao') then
        local identity = quantum.getUserIdentity(user_id)
        
        if (Perimetros[user_id]) then
            return TriggerClientEvent('notify', source, 'Perímetro', 'Você já fechou um <b>perímetro</b>.')
        end

        local prompt = exports.quantum_hud:prompt(source, {
            'Nome do perímetro', 'Distância do perímetro', 'Tempo de perímetro fechado (segundos)'
        })
        if (not prompt) then return; end;
        Perimetros[user_id] = true;

        local name = prompt[1]
        local distance = parseInt(prompt[2])
        local time = parseInt(prompt[3])
        
        TriggerClientEvent('announcement', -1, 'Policia quantum', 'O perímetro <b>'..name..'</b> foi fechado, se afastem imediatamente do local.', identity.firstname, true, 15000)
        TriggerClientEvent('BlipPerimetro', -1, user_id, GetEntityCoords(GetPlayerPed(source)), distance, true)
        exports.quantum:webhook(perimetroWebhook, '```prolog\n[FECHAR PERIMETRO]\n[OFFICER]: '..user_id..'\n[NAME]: '..name..'\n[DISTANCE]: '..distance..'\n[TIME]: '..time..'\n[COORDS]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..'\n```')
        Citizen.SetTimeout(time * 1000, function()
            TriggerClientEvent('announcement', -1, 'Policia quantum', 'O perímetro <b>'..name..'</b> foi aberto.', identity.firstname, true, 15000)
            TriggerClientEvent('BlipPerimetro', -1, user_id, 0, 0, false)
            Perimetros[user_id] = nil
        end)
    end
end)

local reanimarPolicia = 'dndcwebhook/webhooks/1153184742196387952/uxi8pBQQ5Ldgr2n2HBC6xikuZf2hbgvp3hUdjyN9kji1tVKhN3dJxi9w-tbcfKgkbtZk'

RegisterNetEvent('quantum_interactions:reanimarpolicia', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local permissions = quantum.getUsersByPermission('hospital.permissao')
        if (#permissions >= 1) then
            return TriggerClientEvent('notify', source, 'Polícia', 'Você não pode reanimar um <b>policial</b> com paramédicos em serviço!')
        end

        if (not exports.quantum_system:hasCourse(user_id, 'cotem')) then return TriggerClientEvent('notify', source, 'Polícia', 'Você não tem o curso da <b>COTEM</b>!'); end;
        local ped = GetPlayerPed(source)
        if (GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Polícia', 'Sua <b>mão</b> está ocupada.') return; end;
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            if (not quantum.hasPermission(nUser, 'policia.permissao')) then return TriggerClientEvent('notify', source, 'Polícia', 'Você não pode reanimar um <b>civil</b>!'); end;
            if (quantumClient.getNoCarro(nPlayer) and quantumClient.getNoCarro(source)) then return; end;
            if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then
                local cooldown = 'reanimar-pm-'..nPlayer
                if (exports.quantum_core:GetCooldown(cooldown)) then
                    TriggerClientEvent('notify', source, 'Polícia', 'Aguarde <b>'..exports.quantum_core:GetCooldown(cooldown)..' segundos</b> para reanimar novamente.')
                    return
                end
                exports.quantum_core:CreateCooldown(cooldown, 120)

                local reanimarTime = 10

                Player(source).state.BlockTasks = true
                TriggerClientEvent('quantum_animations:setAnim', source, 'reanimar')
                TriggerClientEvent('quantum_macas:reanimar', source, reanimarTime)

                TriggerClientEvent('progressBar', source, 'Reanimando...', reanimarTime * 1000)
                Citizen.SetTimeout(reanimarTime * 1000, function()
                    ClearPedTasks(ped)
                    Player(source).state.BlockTasks = false
                    TriggerClientEvent('quantum_animations:cancelSharedAnimation', source)
                    quantumClient.killGod(nPlayer)
                    quantumClient.setHealth(nPlayer, 105)
                    quantumClient.DeletarObjeto(source)
                    TriggerClientEvent('notify', source, 'Polícia', 'Você reanimou um <b>policial</b>!')
                    quantum.webhook(reanimarPolicia, '```prolog\n[REANIMATION]\n[OFFICER]: '..user_id..'\n[TARGET]: '..nUser..'\n[COORD]: '..tostring(GetEntityCoords(ped))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                end)
            else
                TriggerClientEvent('notify', source, 'Polícia', 'O <b>policial</b> não está em coma!')
            end
        end
    end
end)