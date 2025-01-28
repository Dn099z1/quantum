local carregarSrc = {}
local carregarStarting = {}

RegisterServerEvent('quantum_carry:carryStart', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        if (quantum.getInventoryItemAmount(user_id, 'cordas') >= 1) then
            local sync_player = quantumClient.getNearestPlayer(source, 3)
            if (sync_player) and not carregarStarting[source] then
                carregarStarting[source] = true
                local request = exports.quantum_hud:request(sync_player, 'Voce aceita ser carregado?', 30000)
                if (GetEntityHealth(GetPlayerPed(source)) <= 100 or request) then
                    local animationLib = 'missfinale_c2mcs_1'
                    local animationLib2	= 'nm'
                    local animation = 'fin_c2_mcs_1_camman'
                    local animation2 = 'firemans_carry'
                    local distans = 0.15
                    local distans2 = 0.27
                    local height = 0.63
                    local length = 100000
                    local spin = 0.0			
                    local controlFlagSrc = 49
                    local controlFlagTarget = 33
                    local animFlagTarget = 1
                        
                    carregarSrc[source] = sync_player

                    TriggerClientEvent('quantum_carry:carryTarget', sync_player, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
			        TriggerClientEvent('quantum_carry:carryMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
                end
                carregarStarting[source] = nil
            end
        else
            TriggerClientEvent('notify', source, 'Carregar', 'Você precisa de uma <b>corda</b>!')
        end
    end
end)

RegisterServerEvent('quantum_carry:carryTryStop', function()
	local source = source
	local sync_player = carregarSrc[source]
	if (sync_player) then
		carregarSrc[source] = nil
		TriggerClientEvent('quantum_carry:carryStop', source)
		TriggerClientEvent('quantum_carry:carryStop', sync_player)
	end
end)