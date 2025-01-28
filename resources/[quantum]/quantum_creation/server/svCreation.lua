srv = {}
Tunnel.bindInterface('Creation', srv)
vCLIENT = Tunnel.getInterface('Creation')

quantum.prepare('quantum_character/createUser', 'INSERT IGNORE INTO creation (user_id, controller, user_character, user_tattoo, user_clothes, rh) VALUES (@user_id, @controller, @user_character, @user_tattoo, @user_clothes, @rh)')
quantum.prepare('quantum_character/verifyUser', 'SELECT controller FROM creation WHERE user_id = @user_id')
quantum.prepare('quantum_character/saveUser', 'UPDATE creation SET user_character = @user_character, controller = 1 WHERE user_id = @user_id')

srv.changeSession = function(bucket)
    local _source = source
    SetPlayerRoutingBucket(_source, bucket)
end

srv.verifyIdentity = function(identity)
    local source = source

    if (generalConfig.blacklistNames[identity.firstname] or identity.firstname == '') then
        local text = (identity.firstname == '' and '<b>Nome</b> inválido!' or '<b>'..identity.firstname..'</b> este nome é inválido!')
        TriggerClientEvent('notify', source, 'Criação de Personagem', text)
        return false
    end

    if (string.len(identity.firstname) > 50) then
        TriggerClientEvent('notify', source, 'Criação de Personagem', 'O seu <b>nome</b> não pode passar de <b>50 caracteres</b>.')
        return false
    end

    if (generalConfig.blacklistNames[identity.lastname] or identity.lastname == '') then
        local text = (identity.lastname == '' and '<b>Sobrenome</b> inválido!' or '<b>'..identity.lastname..'</b> este sobrenome é inválido!')
        TriggerClientEvent('notify', source, 'Criação de Personagem', text)
        return false
    end

    if (string.len(identity.lastname) > 50) then
        TriggerClientEvent('notify', source, 'Criação de Personagem', 'O seu <b>sobrenome</b> não pode passar de <b>50 caracteres</b>.')
        return false
    end

    if (identity.age < 18) then
        TriggerClientEvent('notify', source, 'Criação de Personagem', '<b>Idade</b> inválida!')
        return false
    end

    local user_id = quantum.getUserId(source)
    if (user_id) then
        quantum.execute('quantum/update_user_first_spawn', { user_id = user_id, firstname = identity.firstname, lastname = identity.lastname, age = identity.age  } )
        quantum.execute('quantum_framework/money_init_user', { user_id = user_id, wallet = 2500, bank = 5000 })
        quantum.resetIdentity(user_id)
        return true
    end
    return false
end




srv.saveCharacter = function(table)
    local _source = source
    local _userId = quantum.getUserId(_source)
    quantum.giveInventoryItem(_userId, 'celular', 1)
    quantum.giveInventoryItem(_userId, 'sanduiche', 3)
    quantum.giveInventoryItem(_userId, 'suco-abacaxi', 3)
    quantum.giveInventoryItem(_userId, 'tabletmenu', 1)
    if (_userId) then
        quantum.execute('quantum_character/saveUser', { user_id = _userId, user_character = json.encode(table) })
    end
end

local userLogin = {}





AddEventHandler('quantum:playerSpawn', function(user_id, source)    
    local bloodGroup = generalConfig.bloodGroup
    
    quantum.execute('quantum_character/createUser', { 
        user_id = user_id, 
        controller = 0, 
        user_character = json.encode({}), 
        user_tattoo = json.encode({}), 
        user_clothes = json.encode({}), 
        rh = bloodGroup[math.random(#bloodGroup)] 
    })

    vCLIENT.loadingPlayer(source, false) 
    local query = quantum.query('quantum_character/verifyUser', { user_id = user_id })[1]
    if (query) then
        if (query.controller == 1) then
            if (not userLogin[user_id]) then
                userLogin[user_id] = true
                quantum.varyHunger(user_id, -100)     
                quantum.varyThirst(user_id, -100)   
                playerSpawn(source, user_id, true)
            else
                playerSpawn(source, user_id, false)
            end
        else
            userLogin[user_id] = true
            vCLIENT.createCharacter(source)
        end
    end
end)
getUserJob = function(user_id)
    local job, jobinfo = quantum.getUserGroupByType(user_id, 'job')
    if job then
        local jobTitle = quantum.getGroupTitle(job, jobinfo.grade)
        return ''..job..': '..jobTitle
    end
    return 'Desempregado'
end
quantum.prepare('quantum_identity/getUserPhoto', 'select url from identity where user_id = @user_id')
quantum.prepare('quantum_identity/insertPhoto', 'insert into identity (user_id, url) values (@user_id, @url)')

getUserPhoto = function(user_id)
    local query = quantum.query('quantum_identity/getUserPhoto', { user_id = user_id })[1]
    if (query) then
        return query.url
    end

    quantum.execute('quantum_identity/insertPhoto', { user_id = user_id, url = 'https://host-two-ochre.vercel.app/files/valley_sem_fundo.png' })
end

playerSpawn = function(source, user_id, firstSpawn)

    local idData = quantum.getUserIdentity(user_id)
    local UserName = idData.firstname .. " " .. idData.lastname
    local playerJob = getUserJob(user_id)
    local avatar = getUserPhoto(user_id)
    local characters = {
        [1] = { name = UserName, locked = false, id = user_id, job = playerJob, avatar = avatar },
        [2] = { name = "Slot Bloqueado", locked = true },
        [3] = { name = "Slot Bloqueado", locked = true }
    }

    vCLIENT.loadingPlayer(source, true) 
    if (firstSpawn) then
        TriggerClientEvent('quantum_spawn:selector', source, true, characters)
    else
        TriggerClientEvent('quantum_spawn:selector', source, false, characters)
       
    end
    TriggerEvent('quantum_appearance_barbershop:init', user_id)
end
