local srv = {}
Tunnel.bindInterface('Refem', srv)
local vCLIENT = Tunnel.getInterface('Refem')

srv.getClosetPedSource = function()
    local source = source
    local targetSrc = quantumClient.getNearestPlayer(source, 1.5)
    return (targetSrc or 0.0)
end

RegisterCommand('prefem', function(source)
    local targetSrc = quantumClient.getNearestPlayer(source, 1.5)
    if (targetSrc) then
        local ply = GetPlayerPed(source)
        local targetPly = GetPlayerPed(targetSrc)

        if (GetEntityHealth(ply) <= 100 or GetEntityHealth(targetPly) <= 100) then return; end;
        if (quantumClient.isHandcuffed(source)) then return; end;
        if (quantumClient.getNoCarro(source) or  quantumClient.getNoCarro(targetSrc)) then return; end;
        if (Player(source).state.holdingHostage or Player(targetSrc).state.victimHostage) then return; end;
        
        local result = vCLIENT.takeHostage(source, targetSrc)
        if (result) then
            Player(source).state.holdingHostage = true
            Player(targetSrc).state.victimHostage = true
        end
    end
end)

RegisterServerEvent('quantum_prefem:killHostage')
AddEventHandler('quantum_prefem:killHostage', function()
    local source = source
    local nPlayer = quantumClient.getNearestPlayer(source, 2)
    if (nPlayer) then
        quantumClient.killGod(nPlayer)
        quantumClient.setHealth(nPlayer, 0)
        quantumClient.setArmour(nPlayer, 0)
    end
end)
-- RegisterServerEvent('quantum_prefem:sync')
-- AddEventHandler('quantum_prefem:sync', function()
srv.prefemSync = function(targetSrc, animationLib,animationLib2, animation, animation2, distans, distans2, height,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
    local source = source
    Player(source).state.BlockTasks = true
    Player(targetSrc).state.BlockTasks = true
    TriggerClientEvent('quantum_prefem:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
    TriggerClientEvent('quantum_prefem:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end

RegisterServerEvent('quantum_prefem:stop')
AddEventHandler('quantum_prefem:stop', function(targetSrc)
    local source = source    

    Player(source).state.holdingHostage = false
    Player(targetSrc).state.victimHostage = false

    TriggerClientEvent('quantum_prefem:cl_stop', source)
    TriggerClientEvent('quantum_prefem:cl_stop', targetSrc)
end)