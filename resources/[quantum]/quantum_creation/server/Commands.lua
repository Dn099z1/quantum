Cirurgia = function(source)
    vCLIENT.createCharacter(source)
end
exports('Cirurgia', Cirurgia)

RegisterCommand('cirurgia', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Hospital.Medico') then
        local nUser = exports.quantum_hud:prompt(source, {
            'Passaporte do Paciente'
        })

        if (nUser) then
            nUser = parseInt(nUser[1])
            local nIdentity = quantum.getUserIdentity(nUser)

            local nSource = quantum.getUserSource(nUser)
            if (nSource) then
                local request = exports.quantum_hud:request(source, 'Você deseja prosseguir com a cirurgia do paciente '..nIdentity.firstname..' '..nIdentity.lastname..'?', 30000)
                if (request) then
                    exports[GetCurrentResourceName()]:Cirurgia(nSource)
                    TriggerClientEvent('notify', source, 'Cirurgia', 'A cirurgia do seu <b>paciente</b> foi um sucesso!')
                    exports.quantum:webhook('Cirurgia', '```prolog\n[quantum HOSPITAL]\n[ACTION]: (CIRURGIA)\n[USER]: '..user_id..'\n[TARGET]: '..nUser..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                end
            else
                TriggerClientEvent('notify', source, 'Cirurgia', 'O mesmo se encontra <b>offline</b>!')
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:cirurgia', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, '+Hospital.Medico') then
        local nUser = exports.quantum_hud:prompt(source, {
            'Passaporte do Paciente'
        })

        if (nUser) then
            nUser = parseInt(nUser[1])
            local nIdentity = quantum.getUserIdentity(nUser)

            local nSource = quantum.getUserSource(nUser)
            if (nSource) then
                local request = exports.quantum_hud:request(source, 'Você deseja prosseguir com a cirurgia do paciente '..nIdentity.firstname..' '..nIdentity.lastname..'?', 30000)
                if (request) then
                    exports[GetCurrentResourceName()]:Cirurgia(nSource)
                    TriggerClientEvent('notify', source, 'Cirurgia', 'A cirurgia do seu <b>paciente</b> foi um sucesso!')
                    exports.quantum:webhook('Cirurgia', '```prolog\n[quantum HOSPITAL]\n[ACTION]: (CIRURGIA)\n[USER]: '..user_id..'\n[TARGET]: '..nUser..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                end
            else
                TriggerClientEvent('notify', source, 'Cirurgia', 'O mesmo se encontra <b>offline</b>!')
            end
        end
    end
end)