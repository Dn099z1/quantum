sDynamic = {}
interactions = {}
quantum = Proxy.getInterface('quantum')
dbTable = 'dynamic'

Tunnel.bindInterface('quantum_dynamic', sDynamic)
cDynamic = Tunnel.getInterface('quantum_dynamic')

quantum.prepare('quantum_dynamic:getFavorites', 'select * from '..dbTable..' where user_id = @user_id');
quantum.prepare('quantum_dynamic:setFavorite', 'insert into '..dbTable..' (user_id, action) values (@user_id, @action)');
quantum.prepare('quantum_dynamic:deleteFavorite', 'delete from '..dbTable..' where user_id = @user_id and action = @action');


sDynamic.handleAction = function(action, value)
    interactions[action](value)
end

sDynamic.setFavorite = function(action)
    local _source = source
    local user_id = quantum.getUserId(_source)

    quantum.execute('quantum_dynamic:setFavorite', { action = action, user_id = user_id })
    cDynamic.openOrUpdateNui(_source)
end

sDynamic.getFavorites = function()
    local _source = source
    local user_id = quantum.getUserId(_source)
    local favorites = quantum.query('quantum_dynamic:getFavorites', { user_id = user_id })
    local favoritesList = {}
    for k,v in pairs(favorites) do
        table.insert(favoritesList, v.action)
    end

    return favoritesList
end

sDynamic.deleteFavorite = function(action)
    local _source = source
    local user_id = quantum.getUserId(_source)

    quantum.execute('quantum_dynamic:deleteFavorite', { action = action, user_id = user_id })
    cDynamic.openOrUpdateNui(_source)
end

sDynamic.checkPermission = function(permission)
    local _source = source
    local user_id = quantum.getUserId(_source)
    return quantum.hasPermission(user_id, permission)
end