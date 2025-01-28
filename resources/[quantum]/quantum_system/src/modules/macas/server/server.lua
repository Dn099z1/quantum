local srv = {}
Tunnel.bindInterface('Macas', srv)
local vCLIENT = Tunnel.getInterface('Macas')

srv.startTratamento = function(index)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local permissions = quantum.getUsersByPermission('hospital.permissao')
        if (#permissions >= 1) then
            TriggerClientEvent('notify', source, 'Hospital', 'Você não pode utilizar o <b>auto tratamento</b> com paramédicos em serviço!')
            return false
        end
    end
    vCLIENT.setTratamento(source, index)
    return true
end

local tratamentoValue = 1000

RegisterCommand('tratamento', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            if (GetEntityHealth(GetPlayerPed(nPlayer)) >= 200) then  TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está com a vida cheia!') return; end;
            local nUser = quantum.getUserId(nPlayer)
            if (vCLIENT.checkMaca(nPlayer)) then
                local request = exports.quantum_hud:request(nPlayer, 'Você deseja pagar R$'..quantum.format(tratamentoValue)..' no tratamento?', 30000)
                if (request) then
                    if (quantum.tryFullPayment(nUser, tratamentoValue)) then
                        --exports.qbank:extrato(nUser, 'Tratamento', -tratamentoValue)
                        TriggerClientEvent('notify', source, 'Hospital', 'Você iniciou o tratamento no <b>paciente</b>!')
                        quantum.giveBankMoney(user_id, tratamentoValue)
                        --exports.qbank:extrato(user_id, 'Tratamento', tratamentoValue)
                        vCLIENT.setTratamento(nPlayer)
                    else
                        TriggerClientEvent('notify', source, 'Hospital', 'O paciente não possui <b>R$'..quantum.format(tratamentoValue)..'</b> para pagar o tratamento!')
                        TriggerClientEvent('notify', nPlayer, 'Hospital', 'Você não possui <b>R$'..quantum.format(tratamentoValue)..'</b> para pagar o tratamento!')
                    end
                else
                    TriggerClientEvent('notify', source, 'Hospital', 'O paciente não aceitou pagar o <b>tratamento</b>!')
                end
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O paciente não se encontra <b>deitado</b> na maca!')
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:tratamento', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            if (GetEntityHealth(GetPlayerPed(nPlayer)) >= 200) then  TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está com a vida cheia!') return; end;
            local nUser = quantum.getUserId(nPlayer)
            if (vCLIENT.checkMaca(nPlayer)) then
                local request = exports.quantum_hud:request(nPlayer, 'Você deseja pagar R$'..quantum.format(tratamentoValue)..' no tratamento?', 30000)
                if (request) then
                    if (quantum.tryFullPayment(nUser, tratamentoValue)) then
                        --exports.qbank:extrato(nUser, 'Tratamento', -tratamentoValue)
                        TriggerClientEvent('notify', source, 'Hospital', 'Você iniciou o tratamento no <b>paciente</b>!')
                        quantum.giveBankMoney(user_id, tratamentoValue)
                        --exports.qbank:extrato(user_id, 'Tratamento', tratamentoValue)
                        vCLIENT.setTratamento(nPlayer)
                    else
                        TriggerClientEvent('notify', source, 'Hospital', 'O paciente não possui <b>R$'..quantum.format(tratamentoValue)..'</b> para pagar o tratamento!')
                        TriggerClientEvent('notify', nPlayer, 'Hospital', 'Você não possui <b>R$'..quantum.format(tratamentoValue)..'</b> para pagar o tratamento!')
                    end
                else
                    TriggerClientEvent('notify', source, 'Hospital', 'O paciente não aceitou pagar o <b>tratamento</b>!')
                end
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O paciente não se encontra <b>deitado</b> na maca!')
            end
        end
    end
end)

RegisterCommand('anestesia', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local prompt = exports.quantum_hud:prompt(source, { 'Tempo da anestesia' })
        if (prompt) then
            prompt = parseInt(prompt[1])
            local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
            if (nPlayer) then
                if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then  TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está em coma!') return; end;
                local nUser = quantum.getUserId(nPlayer)
                local nIdentity = quantum.getUserIdentity(nUser)
                local request = exports.quantum_hud:request(source, 'Você deseja aplicar anestesia no '..nIdentity.firstname..' '..nIdentity.lastname..'?', 30000)
                if (request) then
                    TriggerClientEvent('notify', source, 'Hospital', 'A <b>anestesia</b> foi aplicada no paciente!')
                    vCLIENT.setAnestesia(nPlayer, prompt)
                end
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:anestesia', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local prompt = exports.quantum_hud:prompt(source, { 'Tempo da anestesia' })
        if (prompt) then
            prompt = parseInt(prompt[1])
            local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
            if (nPlayer) then
                if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then  TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está em coma!') return; end;
                local nUser = quantum.getUserId(nPlayer)
                local nIdentity = quantum.getUserIdentity(nUser)
                local request = exports.quantum_hud:request(source, 'Você deseja aplicar anestesia no '..nIdentity.firstname..' '..nIdentity.lastname..'?', 30000)
                if (request) then
                    TriggerClientEvent('notify', source, 'Hospital', 'A <b>anestesia</b> foi aplicada no paciente!')
                    vCLIENT.setAnestesia(nPlayer, prompt)
                end
            end
        end
    end
end)

local reanimarTime = 10
local reanimarPayment = 500

RegisterCommand('re', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local ped = GetPlayerPed(source)
        if (GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Hospital', 'Sua <b>mão</b> está ocupada.') return; end;
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            if (quantumClient.getNoCarro(nPlayer) and quantumClient.getNoCarro(source)) then return; end;
            local nUser = quantum.getUserId(nPlayer)
            if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then
                local cooldown = 'reanimar-'..nPlayer
                if (exports.quantum_core:GetCooldown(cooldown)) then
                    TriggerClientEvent('notify', source, 'Hospital', 'Aguarde <b>'..exports.quantum_core:GetCooldown(cooldown)..' segundos</b> para reanimar novamente.')
                    return
                end
                exports.quantum_core:CreateCooldown(cooldown, 120)

                Player(source).state.BlockTasks = true
                TriggerClientEvent('quantum_animations:setAnim', source, 'reanimar')
                TriggerClientEvent('quantum_macas:reanimar', source, reanimarTime)

                TriggerClientEvent('progressBar', source, 'Reanimando...', reanimarTime * 1000)
                Citizen.SetTimeout(reanimarTime * 1000, function()
                    Player(source).state.BlockTasks = false
                    TriggerClientEvent('quantum_animations:cancelSharedAnimation', source)
                    quantumClient.killGod(nPlayer)
                    quantumClient.setHealth(nPlayer, 105)
                    quantumClient.DeletarObjeto(source)
                    quantum.giveBankMoney(user_id, reanimarPayment)
                    --exports.qbank:extrato(user_id, 'Reanimar', reanimarPayment)
                    TriggerClientEvent('notify', source, 'Hospital', 'Você reanimou um cidadão e recebeu <b>R$'..quantum.format(reanimarPayment)..'</b>!')
                    quantum.webhook('Reanimar', '```prolog\n[REANIMATION]\n[USER]: '..user_id..'\n[TARGET]: '..nUser..'\n[VALUE RECEIVED]: R$'..quantum.format(reanimarPayment)..'\n[COORD]: '..tostring(GetEntityCoords(ped))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                end)
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> não está em coma!')
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:reanimar', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local ped = GetPlayerPed(source)
        if (GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Hospital', 'Sua <b>mão</b> está ocupada.') return; end;
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            if (quantumClient.getNoCarro(nPlayer) and quantumClient.getNoCarro(source)) then return; end;
            local nUser = quantum.getUserId(nPlayer)
            if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then
                local cooldown = 'reanimar-'..nPlayer
                if (exports.quantum_core:GetCooldown(cooldown)) then
                    TriggerClientEvent('notify', source, 'Hospital', 'Aguarde <b>'..exports.quantum_core:GetCooldown(cooldown)..' segundos</b> para reanimar novamente.')
                    return
                end
                exports.quantum_core:CreateCooldown(cooldown, 120)

                Player(source).state.BlockTasks = true
                TriggerClientEvent('quantum_animations:setAnim', source, 'reanimar')
                TriggerClientEvent('quantum_macas:reanimar', source, reanimarTime)

                TriggerClientEvent('progressBar', source, 'Reanimando...', reanimarTime * 1000)
                Citizen.SetTimeout(reanimarTime * 1000, function()
                    Player(source).state.BlockTasks = false
                    TriggerClientEvent('quantum_animations:cancelSharedAnimation', source)
                    quantumClient.killGod(nPlayer)
                    quantumClient.setHealth(nPlayer, 105)
                    quantumClient.DeletarObjeto(source)
                    quantum.giveBankMoney(user_id, reanimarPayment)
                    --exports.qbank:extrato(user_id, 'Reanimar', reanimarPayment)
                    TriggerClientEvent('notify', source, 'Hospital', 'Você reanimou um cidadão e recebeu <b>R$'..quantum.format(reanimarPayment)..'</b>!')
                    quantum.webhook('Reanimar', '```prolog\n[REANIMATION]\n[USER]: '..user_id..'\n[TARGET]: '..nUser..'\n[VALUE RECEIVED]: R$'..quantum.format(reanimarPayment)..'\n[COORDENADA]: '..tostring(GetEntityCoords(ped))..' '..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
                end)
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> não está em coma!')
            end
        end
    end
end)

RegisterCommand('vacina', function(source)
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local ped = GetPlayerPed(source)
        if (GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Hospital', 'Sua <b>mão</b> está ocupada.') return; end;
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (quantumClient.getNoCarro(nPlayer) and quantumClient.getNoCarro(source)) then return; end;
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            if (GetEntityHealth(GetPlayerPed(nPlayer)) > 100) then
                if (quantum.hasGroup(nUser, 'Hospital')) then
                    TriggerClientEvent('notify', source, 'Hospital', 'Este paciente já foi vacinado contra a <b>virgindade</b>.')
                    return
                end

                Player(source).state.BlockTasks = true
                FreezeEntityPosition(GetPlayerPed(source), true)
                FreezeEntityPosition(GetPlayerPed(nPlayer), true)
                TriggerClientEvent('quantum_animations:setAnim', source, 'mexer')
                TriggerClientEvent('progressBar', source, 'Vacinando o paciente...', 10000)
                Citizen.SetTimeout(10000, function()
                    FreezeEntityPosition(GetPlayerPed(source), false)
                    FreezeEntityPosition(GetPlayerPed(nPlayer), false)
                    ClearPedTasks(GetPlayerPed(source))
                    quantum.addUserGroup(nUser, 'Vacina')
                    TriggerClientEvent('notify', nPlayer, 'Hospital', 'Você foi vacinado contra a <b>virgindade</b>.')
                    TriggerClientEvent('notify', source, 'Hospital', 'Seu paciente foi vacinado contra a <b>virgindade</b>.')
                end)
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está em coma!')
            end
        end
    end
end)

RegisterNetEvent('quantum_interactions:vacinar', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) and quantum.hasPermission(user_id, 'hospital.permissao') then
        local ped = GetPlayerPed(source)
        if (GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED')) then TriggerClientEvent('notify', source, 'Hospital', 'Sua <b>mão</b> está ocupada.') return; end;
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (quantumClient.getNoCarro(nPlayer) and quantumClient.getNoCarro(source)) then return; end;
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)
            if (GetEntityHealth(GetPlayerPed(nPlayer)) > 100) then
                if (quantum.hasGroup(nUser, 'Vacina')) then
                    TriggerClientEvent('notify', source, 'Hospital', 'Este paciente já foi vacinado contra a <b>virgindade</b>.')
                    return
                end

                Player(source).state.BlockTasks = true
                FreezeEntityPosition(GetPlayerPed(source), true)
                FreezeEntityPosition(GetPlayerPed(nPlayer), true)
                TriggerClientEvent('quantum_animations:setAnim', source, 'mexer')
                TriggerClientEvent('progressBar', source, 'Vacinando o paciente...', 10000)
                Citizen.SetTimeout(10000, function()
                    FreezeEntityPosition(GetPlayerPed(source), false)
                    FreezeEntityPosition(GetPlayerPed(nPlayer), false)
                    ClearPedTasks(GetPlayerPed(source))
                    quantum.addUserGroup(nUser, 'Vacina')
                    TriggerClientEvent('notify', nPlayer, 'Hospital', 'Você foi vacinado contra a <b>virgindade</b>.')
                    TriggerClientEvent('notify', source, 'Hospital', 'Seu paciente foi vacinado contra a <b>virgindade</b>.')
                end)
            else
                TriggerClientEvent('notify', source, 'Hospital', 'O <b>paciente</b> está em coma!')
            end
        end
    end
end)