srv = {}
Tunnel.bindInterface(GetCurrentResourceName(), srv)

getLastPosition = function()
    local source = source
    local coords = vector3(-1648.84, -994.1143, 13.00293)
    if (source) then
        local datatable = quantum.getUserDataTable(quantum.getUserId(source))
        if (datatable) and datatable.position then
            local position = datatable.position
            coords = vector3(position.x, position.y, position.z)
        end
    end
    return coords
end



srv.setDm = function()
    source = source
    local dimension = quantum.getUserId(source)
    SetPlayerRoutingBucket(source,dimension)
 
end
srv.returnDm = function()
    source = source
    local dimension = 0
    SetPlayerRoutingBucket(source,dimension)
    quantumClient.DeletarObjeto(source)
        quantumClient._stopAnim(source, false)
   
end

getUserJob = function(user_id)
    local job, jobinfo = quantum.getUserGroupByType(user_id, 'job')
    if job then
        local jobTitle = quantum.getGroupTitle(job, jobinfo.grade)
        return ''..job..': '..jobTitle
    end
    return 'Desempregado'
end



RegisterCommand('openSpawn', function(source)
 
    source = source
    local user_id = quantum.getUserId(source)
    local idData = quantum.getUserIdentity(user_id)
    local UserName = idData.firstname
    local playerJob = getUserJob(user_id)
    local avatar = 'a'
    print(avatar)
    local characters = {
        [1] = { name = UserName, locked = false, id = user_id, job = playerJob , avatar = avatar },
        [2] = { name = "Slot Bloqueado", locked = true },
        [3] = { name = "Slot Bloqueado", locked = true }
    }

    TriggerClientEvent('quantum_spawn:selector', source, true, characters)
end)
