srv = {}
Tunnel.bindInterface(GetCurrentResourceName(), srv)

local configGeneral = config.general
local configShops = config.shops

local checkInventory = function(user_id, item, amount)
    if ((quantum.getInventoryWeight(user_id) + (quantum.getItemWeight(item) * amount)) < quantum.getInventoryMaxWeight(user_id)) then
        return true
    end
    TriggerClientEvent('notify', quantum.getUserSource(user_id), 'Loja', 'Você não possui <b>espaço</b> o suficiente em sua mochila.')
    return false
end

srv.checkPermission = function(permissions)
    local source = source
    local user_id = getUserId(source)
    return quantum.checkPermissions(user_id, permissions)
end

srv.getUserIdentity = function()
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    if (user_id and identity) then
        return identity.firstname..' '..identity.lastname
    end
end

local amountSpent = 0
local earnedValue = 0

local paymentMethod = {
    ['legal'] = function(user_id, item, amount, config, method)
        local source = quantum.getUserSource(user_id)
        local price = parseInt(config.price[method] * amount)
        if (method == 'buy') then
            if (checkInventory(user_id, item, amount)) then
                if (quantum.tryFullPayment(user_id, price)) then
                    quantum.giveInventoryItem(user_id, item, amount)
                    amountSpent = parseInt(amountSpent + price)
                    return true
                else
                    TriggerClientEvent('notify', source, 'Loja', 'Você não possui <b>dinheiro</b> o suficiente em sua conta.')
                end
            end
        else
            if (quantum.tryGetInventoryItem(user_id, item, amount)) then
                quantum.giveMoney(user_id, price)
                earnedValue = parseInt(earnedValue + price)
                return true
            else
                TriggerClientEvent('notify', source, 'Loja', 'Você não possui <b>item</b> o suficiente em seu inventário.')
            end
        end
        return false
    end,
    ['ilegal'] = function(user_id, item, amount, config, method)
        local source = quantum.getUserSource(user_id)
        local price = parseInt(config.price[method] * amount)
        if (method == 'buy') then
            if (checkInventory(user_id, item, amount)) then
                if (quantum.tryGetInventoryItem(user_id, 'dinheirosujo', price)) then
                    quantum.giveInventoryItem(user_id, item, amount)
                    amountSpent = parseInt(amountSpent + price)
                    return true
                else
                    TriggerClientEvent('notify', source, 'Loja', 'Você não possui <b>dinheiro sujo</b> o suficiente em sua conta.')
                end
            end
        else
            if (quantum.tryGetInventoryItem(user_id, item, amount)) then
                quantum.giveInventoryItem(user_id, 'dinheirosujo', price)
                earnedValue = parseInt(earnedValue + price)
                return true
            else
                TriggerClientEvent('notify', source, 'Loja', 'Você não possui <b>item</b> o suficiente em seu inventário.')
            end
        end
        return false
    end,
}

local _finish = {
    ['buy'] = function(source, paidOut, name)
        local user_id = quantum.getUserId(source)
        if (amountSpent > 0) then
            local text = table.concat(paidOut, ', <br>')
            TriggerClientEvent('notify', source, 'Loja', 'A sua compra foi um <b>sucesso</b>.<br><br><b>(Nota Fiscal)</b><br><br>'..text..'<br><br><b>Total: R$'..quantum.format(amountSpent)..'</b>')
         --   exports['qbank']:extrato(user_id, name, -amountSpent)
            quantum.webhook('ShopBuy', '```prolog\n[quantum SHOP]\n[ACTION] (BUY)\n[USER]: '..user_id..' \n[TABLE]: '..json.encode(paidOut, { indent = true })..'\n[TOTAL]: R$'..quantum.format(amountSpent)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\n```')
        end
        amountSpent = 0
    end,
    ['sell'] = function(source, paidOut, name)
        local user_id = quantum.getUserId(source)
        if (earnedValue > 0) then
            local text = table.concat(paidOut, ', <br>')
            TriggerClientEvent('notify', source, 'Loja', 'A sua venda foi um <b>sucesso</b>.<br><br><b>(Nota Fiscal)</b><br><br>'..text..'<br><br><b>Total: R$'..quantum.format(earnedValue)..'</b>')
         --   exports['qbank']:extrato(user_id, name, earnedValue)
            quantum.webhook('ShopSell', '```prolog\n[quantum SHOP]\n[ACTION] (SELL)\n[USER]: '..user_id..' \n[TABLE]: '..json.encode(paidOut, { indent = true })..'\n[TOTAL]: R$'..quantum.format(earnedValue)..os.date('\n[DATA]: %d/%m/%Y [HORA]: %H:%M:%S')..'\n```')
        end
        earnedValue = 0
    end
}

srv.shopTransaction = function(cart, method, index)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local paidOut = {}
        for k, v in pairs(cart) do
            local itemConfig = configGeneral[configShops[index].config][k] 
            if (quantum.checkPermissions(user_id, itemConfig.perm)) then
                local itemMethod = itemConfig.method
                if (method == 'buy') then
                    if (paymentMethod[itemMethod](user_id, k, v.amount, itemConfig, 'buy')) then
                        table.insert(paidOut, v.amount..'x '..quantum.itemNameList(k))
                    end
                else
                    if (paymentMethod[itemMethod](user_id, k, v.amount, itemConfig, 'sell')) then
                        table.insert(paidOut, v.amount..'x '..quantum.itemNameList(k))
                    end
                end
            else
                TriggerClientEvent('notify', source, 'Loja', 'Você não tem <b>permissão</b> para comprar este item!')
            end
        end
        _finish[method](source, paidOut, configShops[index].name)
    end
end