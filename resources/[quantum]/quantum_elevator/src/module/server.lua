srv = {}
Tunnel.bindInterface(GetCurrentResourceName(), srv)

local permission = {
    ['perm'] = function(user_id, perm, home)
        return quantum.checkPermissions(user_id, perm)
    end,
    ['home'] = function(user_id, perm, home)
        return exports['quantum_homes']:checkHomePermission(user_id, home)
    end
}

srv.checkPermissions = function(perm, home)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local isHome = (home and 'home' or 'perm')
        return permission[isHome](user_id, perm, home)
    end
end