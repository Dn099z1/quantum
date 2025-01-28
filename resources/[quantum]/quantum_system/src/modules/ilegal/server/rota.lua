local srv = {}
Tunnel.bindInterface('Routes', srv)

local routeTime = {}

local selection = {}

srv.startUpdateRoute = function()
    local source = source
    selection[quantum.getUserId(source)] = 1
end

srv.resetUpdateRoute = function()
    local source = source
    selection[quantum.getUserId(source)] = nil
end

local updateRoute = function(source, routes)
    local user_id = quantum.getUserId(source)
    
    selection[user_id] = selection[user_id] + 1
    if (selection[user_id] > #routes) then
        selection[user_id] = 1 
    end
end

srv.checkRoutes = function(index)
    local _config = Routes.locations[index]
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.checkPermissions(user_id, _config.perm) then
        if _config.notPerm then
            if quantum.checkPermissions(user_id, _config.notPerm) then
                TriggerClientEvent('notify', source, 'Rotas', 'Você não pode fazer esta rota.')
                return false
            end
        end 
        
        if (GetPlayerRoutingBucket(source) ~= 0) then
            TriggerClientEvent('notify', source, 'Rotas', 'Você não pode iniciar uma rota em outro <b>mundo</b>.')
            return false
        end

        if (routeTime[user_id]) then
            TriggerClientEvent('notify', source, 'Rotas', 'Aguarde <b>'..routeTime[user_id]..' segundos</b> para iniciar uma rota novamente.')
            return false
        end
        registerRoutesTime(user_id, _config.cooldown)
        return true
    end
    return false
end

local check = {
    ['with-receive'] = function(user_id, item, quantity, receive, payment)
        if ((quantum.getInventoryWeight(user_id) + (quantum.getItemWeight(receive) * payment)) <= quantum.getInventoryMaxWeight(user_id)) then
            if (quantum.getInventoryItemAmount(user_id, item) >= quantity) then
                return true
            end
        end
        return false
    end,
    ['without-receive'] = function(user_id, item, quantity, receive, payment)
        if ((quantum.getInventoryWeight(user_id) + (quantum.getItemWeight(item) * quantity)) <= quantum.getInventoryMaxWeight(user_id)) then
            return true
        end
        return false
    end
}

local CheckWeight = function(user_id, item, quantity, receive, payment)
    local _receive = (not receive and 'without-receive' or 'with-receive')
    return check[_receive](user_id, item, quantity, receive, payment)
end

srv.checkBackpack = function(itens, drug)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        if (drug) then
            for k, v in pairs(itens) do
                if (CheckWeight(user_id, v.item, v.quantity, v.receive, v.payment)) then
                    return true
                end
            end
        else
            if (CheckWeight(user_id, itens.item, itens.quantity)) then
                return true
            end
        end
    end
    TriggerClientEvent('notify', source, 'Rotas', 'Você não possui os <b>itens</b> necessários para realizar esta rota ou não possui espaço em sua <b>mochila</b>!')
    return false
end

srv.routePayment = function(coords, _config, drug, name)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local distance = #(GetEntityCoords(GetPlayerPed(source)) - coords[selection[user_id]])
        if (distance <= 8.0) then
            local itens = _config.itens
            if (drug) then
                for k, v in pairs(itens) do
                    if (CheckWeight(user_id, v.item, v.quantity, v.receive, v.payment)) then
                        if (quantum.tryGetInventoryItem(user_id, v.item, v.quantity)) then
                            quantum.giveInventoryItem(user_id, v.receive, v.payment)
                            TriggerClientEvent('notify', source, 'Rotas', 'Você vendeu <b>'..v.quantity..'x</b> de <b>'..quantum.itemNameList(v.item)..'</b> e recebeu <b>R$'..quantum.format(v.payment)..'</b> de dinheiro sujo pela sua venda!')
                            quantum.webhook('Rotas', '```prolog\n[ROUTES]\n[NAME]: '..name..'\n[USER]: '..user_id..'\n[TYPE]: DRUG\n[ITEM SELL]: '..quantum.itemNameList(v.item)..'\n[QUANTITY SELL]: '..v.quantity..'\n[ITEM RECEIVED]: '..quantum.itemNameList(v.receive)..'\n[VALUE RECEIVED]: R$'..quantum.format(v.payment)..' dinheiro sujo\n[COORDENADA]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                            updateRoute(source, coords)
                            return true
                        end
                        TriggerClientEvent('notify', source, 'Rotas', 'Você não possui <b>'..v.quantity..'x</b> de <b>'..quantum.itemNameList(v.item)..'</b> em sua mochila!')
                    end
                end
            else
                if (CheckWeight(user_id, itens.item, itens.quantity)) then
                    quantum.giveInventoryItem(user_id, itens.item, itens.quantity)
                    if _config.points then
                        exports.quantum_reputation:addAutoRep(source, 'Rota de farm', _config.points)
                    end
                    TriggerClientEvent('notify', source, 'Rotas', 'Você recebeu <b>'..itens.quantity..'x</b> de <b>'..quantum.itemNameList(itens.item)..'</b>!')
                    quantum.webhook('Rotas', '```prolog\n[ROUTES]\n[NAME]: '..name..'\n[USER]: '..user_id..'\n[ITEM RECEIVED]: '..quantum.itemNameList(itens.item)..'\n[QUANTITY RECEIVED]: '..itens.quantity..'\n[COORDENADA]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                    updateRoute(source, coords)
                    return true
                end
            end
        else
            TriggerClientEvent('notify', source, 'Rotas', 'Você caiu no nosso sistema de <b>anti-dump</b> e não recebeu os itens da rota, cancele a rota e faça novamente. Por gentileza, na próxima rota não saia de perto do blip!')
            quantum.webhook('AntiDump', '```prolog\n[ANTI DUMP]\n[USER]: '..user_id..'\n[SCRIPT]: '..GetCurrentResourceName()..'\n[ALERT]: provavelmente este jogador está tentando dumpar em um dos nossos sistemas!'..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\n```'..'@everyone')
            print('^5[quantum Anti]^7 o usuário '..user_id..' está provavelmente tentando dumpar!')
        end
    end
    return false
end

srv.callPolice = function(porcentage, name)
    local source = source
    local user_id = quantum.getUserId(source)
    local pCoord = GetEntityCoords(GetPlayerPed(source))
    local porcentagem = math.random(100)
    if (porcentagem >= porcentage) then
        local police = quantum.getUsersByPermission('policia.permissao')
        for k, v in pairs(police) do
            local nSource = quantum.getUserSource(parseInt(v))
            if (nSource) then
                async(function()
                    TriggerClientEvent('quantum_routes:Blip', nSource, pCoord, user_id)
                    TriggerClientEvent('notifypush', nSource, {
                        code = 'QRU',
                        title = 'Tráfico avistado',
                        description = 'Denúncia Anônima',
                        coords = pCoord
                    })
                end)
            end
        end
        quantum.webhook('RotasDenuncia', '```prolog\n[ROUTES]\n[NAME]: '..name..'\n[USER]: '..user_id..'\n[PORCENTAGE]: '..porcentage..'\n[COORDENADA]: '..tostring(GetEntityCoords(GetPlayerPed(source)))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
        TriggerClientEvent('notify', source, 'Rotas', 'Os <b>coxinhas</b> foram alertados, saia do local imediatamente.')
    end
end

registerRoutesTime = function(id, time)
    routeTime[id] = time
    Citizen.CreateThread(function()
        while (routeTime[id] > 0) do
            Citizen.Wait(1000)
            routeTime[id] = (routeTime[id] - 1)
        end
        routeTime[id] = nil
    end)
end