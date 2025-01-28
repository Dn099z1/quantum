RegisterNetEvent('quantum:revistar')
AddEventHandler('quantum:revistar', function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
        if (nPlayer) then
            local nUser = quantum.getUserId(nPlayer)

            if (Player(nPlayer).state.Revistar) then 
                TriggerClientEvent('notify', source, 'Revistar', 'Este <b>cidadão</b> já está sendo revistado!') 
                return 
            end
            
            if (GetEntityHealth(GetPlayerPed(source)) <= 100) then return end
            
            if (GetEntityHealth(GetPlayerPed(nPlayer)) <= 100) then 
                TriggerClientEvent('notify', source, 'Revistar', 'Você não pode <b>revistar</b> uma pessoa morta!') 
                return 
            end
            
            if (quantumClient.getNoCarro(nPlayer)) then return end

            if (quantumClient.isHandcuffed(nPlayer)) then
                Player(source).state.Revistar = true
                Player(nPlayer).state.Revistar = true

                Player(source).state.BlockTasks = true
                Player(nPlayer).state.BlockTasks = true

                quantumClient._playAnim(source, true, {
                    { 'oddjobs@shop_robbery@rob_till', 'loop' }
                }, true)

                TriggerClientEvent('quantum:attach', nPlayer, source, 4103, 0.1, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, 2, true)

        

                cInventory.openInventory(source, 'open', 'bag:'..nUser, true)
            else
                TriggerClientEvent('notify', source, 'Revistar', 'Você não pode <b>revistar</b> uma pessoa desalgemada!')
            end
        end
    end
end)

RegisterCommand("getPlayerInfo", function(source, args, rawCommand)
    local player = source
    local playerName = GetPlayerName(player)
    local playerLevel = 10  -- Substitua pelo método real para pegar o nível do jogador
    local playerAvatar = "https://media.discordapp.net/attachments/725482717877370902/1322232046654984192/image.png?ex=6770200d&is=676ece8d&hm=1a35e7f0e7643ec3a81cf2774a6d744c91ebc1fb984e361a5c85007f2298c55f&=&format=webp&quality=lossless"  -- Defina a URL real do avatar aqui

    local playerInfo = {
        name = playerName,
        level = playerLevel,
        avatar = playerAvatar
    }

    -- Envia a informação para a NUI
    TriggerClientEvent('sendPlayerInfoToNUI', player, playerInfo)
end, false)


RegisterNetEvent('quantum_inventory:closeRevistar', function()
    local source = source
    local nPlayer = quantumClient.getNearestPlayer(source, 2.0)
    if (nPlayer) then
        Player(nPlayer).state.Revistar = false
        Player(nPlayer).state.BlockTasks = false
        TriggerClientEvent('quantum:attach', nPlayer, source)
    end
    Player(source).state.Revistar = false
    Player(source).state.BlockTasks = false
    ClearPedTasks(GetPlayerPed(source))
end)