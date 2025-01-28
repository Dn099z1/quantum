if IsDuplicityVersion() then
    webhook = function(link, message)
        if link and message and link ~= '' then
            PerformHttpRequest(link, function(err, text, headers) end, 'POST', json.encode({ content = message }), { ['Content-Type'] = 'application/json' })
        end
    end

    getUserId = function(source)
        return quantum.getUserId(source)
    end

    getUserIdentity = function(user_id)
        return quantum.getUserIdentity(user_id)
    end

    getIdentity = function(identity)
        return identity['firstname']..' '..identity['lastname']
    end

    hasPermission = function(user_id, permission)
        return quantum.hasPermission(user_id, permission)
    end

    getGroupTitle = function(permission)
        return quantum.getGroupTitle(permission)
    end

    giveWeapons = function(source, weapons, clear)
        return quantumClient.giveWeapons(source, weapons, clear, GlobalState.weaponToken)
    end

    getWeapons = function(source)
        return quantumClient.getWeapons(source)
    end

    getInventoryItemAmount = function(user_id, item)
        return quantum.getInventoryItemAmount(user_id, item)
    end

    giveInventoryItem = function(user_id, item, quantity)
        return quantum.giveInventoryItem(user_id, item, quantity)
    end

    itemNameList = function(item)
        return quantum.itemNameList(item)
    end

    getInventoryWeight = function(user_id)
        return quantum.getInventoryWeight(user_id)
    end

    getItemWeight = function(item)
        return quantum.getItemWeight(item)
    end

    getInventoryMaxWeight = function(user_id)
        return quantum.getInventoryMaxWeight(user_id)
    end

    serverNotify = function(source, message)
        TriggerClientEvent('notifyArsenal', source, message, 3000)
    end
else
    getWeapons = function()
        return quantum.getWeapons()
    end

    threadMarker = function(config)
        TextFloating('~b~E~w~ - Abrir arsenal', config.coord.xyz)
    end

    openFunction = function()
        TriggerEvent('Notify:Toogle', false) 
        TriggerEvent('s9_hud:toggleHud', false)
    end

    closeFunction = function()
        TriggerEvent('Notify:Toogle', true) 
        TriggerEvent('s9_hud:toggleHud', true)
    end

    clientNotify = function(message)
        TriggerEvent('notifyArsenal', message, 3000)
    end
end

TextFloating = function(text, coord)
    AddTextEntry('FloatingHelpText', text)
    SetFloatingHelpTextWorldPosition(0, coord)
    SetFloatingHelpTextStyle(0, true, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpText')
    EndTextCommandDisplayHelp(1, false, false, -1)
end
