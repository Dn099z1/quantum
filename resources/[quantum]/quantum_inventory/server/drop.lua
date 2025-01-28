droppedItems = {}

function createDropId(coords, user_id)
    return os.time()..coords.x..coords.y..coords.z..user_id
end

function contains(table, item)
    for _, v in ipairs(table) do
        if v == item then
            return true
        end
    end
    return false
end

sInventory.dropItem = function(item, pos, amount)
    local _source = source
    local user_id = quantum.getUserId(_source)

    -- Lista de itens para checar
 

    -- Verificando se o item está na blacklist (já existente)
    if (config.blacklist[item.index]) then 
        TriggerClientEvent('notify', source, 'Inventário', 'Você não pode executar esta ação com este <b>item</b>.')
        return
    end

         local itemName = item.index 
 
        if contains(config.functions.weaponMap, itemName) then
            print('é sim')
            
            TriggerClientEvent('inventory:unequipWeapon',source, itemName)
        else
           print('ne nao')
        end

    -- Continuando a execução normal do código
    if sInventory.tryGetInventoryItem(user_id, item.index, amount) then
        quantum.formatWebhook('dropItem', 'Dropar item', {
            { 'item', item.index },
            { 'id', user_id },
            { 'qtd', amount }
        })
        local playerCoords = GetEntityCoords(GetPlayerPed(_source))
        local dropId = createDropId(playerCoords, user_id)
        
        local currentItem = item
        currentItem.amount = amount
        
        -- Criando marker
        local marker = { id = dropId, item = currentItem, coords = playerCoords, time = config.dropped_item_time }
        local itemId = 0
        local nestestDroppedItems = cInventory.getGroundItems(_source)
        for i, v in pairs(nestestDroppedItems) do
            if v.index == item.index then 
                itemId = v.id
            end
        end
        
        if itemId ~= 0 then
            for i, v in pairs(droppedItems) do
                if v.id == itemId then
                    droppedItems[i].item.amount = tonumber(droppedItems[i].item.amount) + tonumber(amount)
                    droppedItems[i].time = config.dropped_item_time
                end
            end
        else 
            table.insert(droppedItems, marker)
        end
        
        TriggerClientEvent('updateDroppedItems', -1, droppedItems)
    else
        config.functions.serverNotify(_source, config.texts.notify_title, config.texts.notify_non_existent_item)
    end
end


sInventory.getDroppedItem = function(id, amount)
    local _source = source
    local user_id = quantum.getUserId(_source)
    local currentItem = nil

    for i,v in pairs(droppedItems) do
        if v.id == id then
            if tonumber(amount) <= tonumber(v.item.amount) then
                currentItem = v.item.index
                if tonumber(v.item.amount) == tonumber(amount) then
                    table.remove(droppedItems, i)
                else
                    droppedItems[i].item.amount = tonumber(droppedItems[i].item.amount) - tonumber(amount)
                end
            end
        end
    end

    if currentItem ~= nil then
        sInventory.giveInventoryItem(user_id, currentItem, amount)
        quantum.formatWebhook('getItem', 'Pegar item', {
            { 'item', currentItem },
            { 'id', user_id },
            { 'qtd', amount },
        })
    else
        config.functions.serverNotify(_source, config.texts.notify_title, config.texts.notify_non_existent_item)
    end

    TriggerClientEvent('updateDroppedItems', -1, droppedItems)
end

AddEventHandler("quantum:playerSpawn", function(_,source,first_spawn)
    if first_spawn then
        for k,v in pairs(droppedItems) do
            TriggerClientEvent('setDrop', source, v)
        end
    end
end)