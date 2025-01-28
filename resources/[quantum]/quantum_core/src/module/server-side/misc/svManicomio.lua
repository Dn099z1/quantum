local typeManicomio = {
    ['colocar'] = function(source, user_id)
        local prompt = exports.quantum_hud:prompt(source, {
            'Passaporte do jogador', 'Motivo da prisão', 'Tempo da prisão'
        })

        if (prompt) and prompt[1] and prompt[2] and prompt[3] then
            local nUser = parseInt(prompt[1])
            local Reason = prompt[2]
            local Time = parseInt(prompt[3])

            local nIdentity = quantum.getUserIdentity(nUser)
            local request = exports.quantum_hud:request(source, 'Você tem certeza que deseja prender o '..nIdentity.firstname..' '..nIdentity.lastname..' por '..Time..' meses?', 60000)
            if (request) then
                local nSource = quantum.getUserSource(nUser)
                if (nSource) then
                    local oldTime = (json.decode(quantum.getUData(user_id, 'quantum:prison_adm')) or 0)
                    quantum.setUData(nUser, 'quantum:prison_adm', json.encode(parseInt(oldTime + Time)))

                    if (quantumClient.isHandcuffed(nSource)) then
                        Player(nSource).state.Handcuff = false
                        quantumClient.setHandcuffed(nSource, false)
                        TriggerClientEvent('quantum_core:uncuff', nSource)
                    end
                    
                    local prisonCoord = vector4(-110.6769, 7488.092, 5.808105, 201.2598)
                    SetEntityHeading(GetPlayerPed(nSource), prisonCoord.w)
                    quantumClient.teleport(nSource, prisonCoord.x, prisonCoord.y, prisonCoord.z)
                    TriggerClientEvent('quantum_animations:setAnim', nSource, 'deitar3')

                    manicomioLock(nSource, nUser)
                    
                    TriggerClientEvent('quantum_sound:source', nSource, 'jaildoor', 0.3)
					TriggerClientEvent('quantum_sound:source', source, 'jaildoor', 0.3)

                    TriggerClientEvent('notify', source, 'Manicômio', 'Você prendeu o <b>'..nIdentity.firstname..' '..nIdentity.lastname..'</b> por <b>'..Time..' meses</b>.')
                    TriggerClientEvent('notify', nSource, 'Manicômio', 'Você foi preso por <b>'..Time..' meses</b>.')

                    Player(nSource).state.Asylum = true

                    quantumClient.playSound(source, 'Hack_Success', 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS')

                    quantum.webhook('Manicomio', '```prolog\n[ASYLUM]\n[ACTION]: (LEARN)\n[STAFF]: '..user_id..'\n[TARGET]: '..nUser..'\n[REASON]: '..Reason..'\n[TIME]: '..Time..' months'..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                else
                    TriggerClientEvent('notify', source, 'Manicômio', 'O mesmo se encontra <b>offline</b>!')
                end
            end
        end
    end,
    ['retirar'] = function(source, user_id)
        local prompt = exports.quantum_hud:prompt(source, {
            'Passaporte do jogador', 'Motivo'
        })

        if (prompt) and prompt[1] and prompt[2] then
            local nUser = parseInt(prompt[1])
            local Reason = prompt[2]

            local nIdentity = quantum.getUserIdentity(nUser)
            local request = exports.quantum_hud:request(source, 'Você tem certeza que deseja soltar o '..nIdentity.firstname..' '..nIdentity.lastname..'?', 60000)
            if (request) then
                local nSource = quantum.getUserSource(nUser)
                if (nSource) then
                    Player(nSource).state.Asylum = false
                    quantum.setUData(nUser, 'quantum:prison_adm', json.encode(-1))
                    SetEntityHeading(GetPlayerPed(nSource), 201.2598)
                    quantumClient.teleport(nSource, -110.6769, 7488.092, 5.808105)

                    TriggerClientEvent('notify', nSource, 'Manicômio', 'Você foi <b>solto</b>!')
                    TriggerClientEvent('notify', source, 'Manicômio', 'Você soltou o <b>'..nIdentity.firstname..' '..nIdentity.lastname..'</b>.')

                    quantum.webhook('Manicomio', '```prolog\n[ASYLUM]\n[ACTION]: (UNFASTEN)\n[STAFF]: '..user_id..'\n[TARGET]: '..nUser..'\n[REASON]: '..Reason..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                else
                    TriggerClientEvent('notify', source, 'Manicômio', 'O mesmo se encontra <b>offline</b>!')
                end
            end
        end        
    end
}

RegisterCommand('manicomio', function(source, args)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.checkPermissions(user_id, { 'staff.permissao' }) then
        if (args[1]) then
            if (typeManicomio[args[1]]) then
                typeManicomio[args[1]](source, user_id)
            else
                TriggerClientEvent('notify', source, 'Manicômio', 'Você não especificou o que deseja fazer, tente novamente com: <br><br><b>- /manicomio colocar<br>- /manicomio retirar', 6000)
            end
        else
            TriggerClientEvent('notify', source, 'Manicômio', 'Você não especificou o que deseja fazer, tente novamente com: <br><br><b>- /manicomio colocar<br>- /manicomio retirar', 6000)
        end
    end
end)

RegisterNetEvent('quantum_interactions:manicomio', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.checkPermissions(user_id, { 'staff.permissao' }) then
        typeManicomio['colocar'](source, user_id)
    end
end)

RegisterNetEvent('quantum_interactions:rmanicomio', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.checkPermissions(user_id, { 'staff.permissao' }) then
        typeManicomio['retirar'](source, user_id)
    end
end)

manicomioLock = function(source, user_id)
    Citizen.SetTimeout(60000, function()
        local time = (json.decode(quantum.getUData(user_id, 'quantum:prison_adm')) or 0)
        time = parseInt(time)
        if (time > 0) then
            quantum.setUData(user_id, 'quantum:prison_adm', json.encode(time - 1))
            TriggerClientEvent('notify',source, 'Manicômio', 'Você ainda vai passar <b>'..time..' meses</b> preso.')
            manicomioLock(source, user_id)
        else
            Player(source).state.Asylum = false
            quantum.setUData(user_id, 'quantum:prison_adm', json.encode(-1))
            SetEntityHeading(GetPlayerPed(source), 201.2598)
            quantumClient.teleport(source, -110.6769, 7488.092, 5.808105)
            TriggerClientEvent('notify', source, 'Manicômio', 'Sua <b>sentença</b> terminou.')
        end
        quantumClient.killGod(source)
    end)
end

AddEventHandler('quantum:playerSpawn', function(user_id, source, first_spawn)
    local tempo = (json.decode(quantum.getUData(parseInt(user_id),'quantum:prison_adm')) or -1)
    if (tempo == -1) then return; end;

    if (tempo > 0) then
        local prisonCoord = vector4(-110.6769, 7488.092, 5.808105, 201.2598)
        SetEntityHeading(GetPlayerPed(source), prisonCoord.w)
        quantumClient.teleport(source, prisonCoord.x, prisonCoord.y, prisonCoord.z)
        TriggerClientEvent('quantum_animations:setAnim', source, 'deitar3')
        Citizen.SetTimeout(5000, function()
            manicomioLock(source, user_id)
            Player(source).state.Asylum = true
        end)
    end
end)