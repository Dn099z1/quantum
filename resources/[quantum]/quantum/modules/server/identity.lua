------------------------------------------------------------------
-- GENERATE FUNCTIONS
------------------------------------------------------------------
quantum.generateStringNumber = function(format)
    local abyte = string.byte('A')
    local zbyte = string.byte('0')
    local number = ''
    for i = 1, #format do
        local char = string.sub(format, i, i)
        if char == 'D' then
            number = number .. string.char(zbyte + math.random(0, 9))
        elseif char == 'L' then
            number = number .. string.char(abyte + math.random(0, 25))
        else
            number = number .. char
        end
    end
    return number
end

quantum.generateRegistrationNumber = function()
    local user_id = nil
    local registration = ''
    repeat
        registration = quantum.generateStringNumber('LLDDDDLL')
        user_id = quantum.getUserByRegistration(registration)
    until not user_id
    return registration
end

quantum.generatePhoneNumber = function()
    local user_id = nil
    local phone = ''
    repeat
        phone = quantum.generateStringNumber('DDDD-DDDD')
        user_id = quantum.getUserByPhone(phone)
    until not user_id
    return phone
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER IDENTITY
------------------------------------------------------------------
quantum.getUserIdentity = function(user_id)
    if user_id then
        local result = exports.oxmysql:executeSync('SELECT * FROM user_identities WHERE user_id = ?', { user_id })
        if result and result[1] then
            result[1].name = result[1].firstname
            return result[1]
        end
    end
    return nil
end

vRP.getUserIdentity = quantum.getUserIdentity
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER BY REGISTRATION
------------------------------------------------------------------
quantum.getUserByRegistration = function(registration)
    if registration then
        local result = exports.oxmysql:executeSync('SELECT user_id FROM user_identities WHERE registration = ?', { registration })
        if result and result[1] then
            return result[1].user_id
        end
    end
    return nil
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER BY PLATE
------------------------------------------------------------------
quantum.getUserByPlate = function(plate)
    if plate then
        local result = exports.oxmysql:executeSync('SELECT user_id FROM user_vehicles WHERE plate = ?', { plate })
        if result and result[1] then
            return result[1].user_id
        end
    end
    return nil
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET USER BY PHONE
------------------------------------------------------------------
quantum.getUserByPhone = function(phone)
    if phone then
        local result = exports.oxmysql:executeSync('SELECT user_id FROM user_identities WHERE phone = ?', { phone })
        if result and result[1] then
            return result[1].user_id
        end
    end
    return nil
end
------------------------------------------------------------------

------------------------------------------------------------------
-- RESET IDENTITY
------------------------------------------------------------------
quantum.resetIdentity = function(user_id)
    -- Não há necessidade de resetar nada, pois o cache foi removido.
end
------------------------------------------------------------------

AddEventHandler('quantum:playerJoin', function(source, user_id)
    if not quantum.getUserIdentity(user_id) then
        exports.oxmysql:execute('INSERT IGNORE INTO user_identities (user_id, registration, phone, lastname, firstname, age) VALUES (?, ?, ?, ?, ?, ?)', {
            user_id,
            quantum.generateRegistrationNumber(),
            quantum.generatePhoneNumber(),
            'Indigente',
            'Individuo',
            18
        })
    end
end)

AddEventHandler('quantum:playerSpawn', function(user_id, source, first_spawn)
    local identity = quantum.getUserIdentity(user_id)
    if identity then
        quantumClient._setRegistrationNumber(source, (identity.registration or 'AA000AAA'))
    end
end)
