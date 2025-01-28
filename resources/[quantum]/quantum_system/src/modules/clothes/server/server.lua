local srv = {}
Tunnel.bindInterface('Clothes', srv) 
local vCLIENT = Tunnel.getInterface('Clothes')

quantum.prepare('quantum_clothes:insertPreset', 'insert into clothes (title, preset, user_id) values (@title, @preset, @user_id)')
quantum.prepare('quantum_clothes:getAllPresets', 'select * from clothes where user_id = @user_id')
quantum.prepare('quantum_clothes:getPreset', 'select * from clothes where user_id = @user_id and title = @title')
quantum.prepare('quantum_clothes:deletePreset', 'delete from clothes where title = @title and user_id = @user_id')
quantum.prepare('quantum_clothes:deleteAllPreset', 'delete from clothes where user_id = @user_id')

srv.getAllPresets = function()
    local _source = source
    local user_id = quantum.getUserId(_source)
    return quantum.query('quantum_clothes:getAllPresets', { user_id = user_id })
end

srv.verifyVip = function(user_id)
    local groups = quantum.getUserGroups(user_id)
    local maxPresets = Clothes.vips['default'];

    for k,v in pairs(groups) do
        local currentGroup = Clothes.vips[v.grade]
        if currentGroup and currentGroup > maxPresets then
            maxPresets = currentGroup
        end 
    end

    return maxPresets
end

srv.verifyTitlePreset = function(presets, title)
    local titleExists = false
    for k,v in pairs(presets) do
        if v.title == title then 
            titleExists = true
        end 
    end
    return titleExists
end

srv.addPreset = function()
    local _source = source
    local user_id = quantum.getUserId(_source)
    local result = exports.quantum_hud:prompt(_source, {
        'Escolha um nome para o seu novo preset!'
    })
    if result then
        result = result[1]
        local presets = quantum.query('quantum_clothes:getAllPresets', { user_id = user_id })
        if #presets < srv.verifyVip(user_id) then
            if srv.verifyTitlePreset(presets, result) then
                TriggerClientEvent('notify', _source, 'Roupas', 'Você já possui um preset com esse nome!')
            else
                local currentPreset = vCLIENT.getCurrentPreset(_source)
                quantum.execute('quantum_clothes:insertPreset', { title = result, user_id = user_id, preset = json.encode(currentPreset) })
                TriggerClientEvent('notify', _source, 'Roupas', 'Preset de roupas <b>'..result..'</b> salvo com sucesso!')
            end
        else
            TriggerClientEvent('notify', _source, 'Roupas', 'Você não possui slots suficientes para cadastrar um novo preset de roupas!')
        end
    end
end
RegisterNetEvent('quantum_interactions:addPreset', srv.addPreset)

srv.usePreset = function(presetTitle)
    local _source = source
    local user_id = quantum.getUserId(_source)
    if (user_id) then
        local savedPreset = quantum.query('quantum_clothes:getPreset', { user_id = user_id, title = presetTitle })[1]
        if (savedPreset) and savedPreset.preset then
            vCLIENT.setClothes(_source, json.decode(savedPreset.preset))
            quantum.execute('quantum_appearance/saveClothes', { user_id = user_id, user_clothes = savedPreset.preset })
        end
    end
end
RegisterNetEvent('quantum_interactions:usePreset', srv.usePreset)

srv.deletePreset = function()
    local _source = source
    local user_id = quantum.getUserId(_source)

    local result = exports.quantum_hud:prompt(_source, {
        'Qual o nome do preset que você deseja deletar?'
    })
    
    if result then
        result = result[1]
        quantum.execute('quantum_clothes:deletePreset', { title = result, user_id = user_id })
        TriggerClientEvent('notify', _source, 'Roupas', 'Preset deletado com sucesso!')
    end
end
RegisterNetEvent('quantum_interactions:deletePreset', srv.deletePreset)

srv.deleteAllPreset = function()
    local _source = source
    local user_id = quantum.getUserId(_source)

    local request = quantum.request(_source, 'Você deseja realmente deletar todos os presets de roupa?', 15000)
    if request then
        quantum.execute('quantum_clothes:deleteAllPreset', { user_id = user_id })
        TriggerClientEvent('notify', _source, 'Roupas', 'Presets deletados com sucesso!')
    end
end
RegisterNetEvent('quantum_interactions:deleteAllPreset', srv.deleteAllPreset)