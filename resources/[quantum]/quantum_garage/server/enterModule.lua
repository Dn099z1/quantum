local srv = {}
Tunnel.bindInterface('Enter', srv)
local vCLIENT = Tunnel.getInterface('Enter')

srv.checkHomeExists = function(specificHomeValue)
    local result = exports.oxmysql:executeSync('SELECT home FROM homes_garages WHERE home = @home', {
        ['@home'] = specificHomeValue
    })


    if result and #result > 0 then
        return true 
    else
        return false 
    end
end