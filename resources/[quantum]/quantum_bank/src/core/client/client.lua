Citizen.CreateThread(function() 
	Wait(1000)
	TriggerServerEvent(GetCurrentResourceName()..':auth', tostring(GetCurrentServerEndpoint()):gsub('.+:(%d+)','%1'))
end)

local temp = {}

RegisterNetEvent('quantum_bank:client:setNui')
AddEventHandler('quantum_bank:client:setNui', function(authData, nuiData, cryptoData)
    quantum_bank['config']['authorized'] = authData
    temp[1] = nuiData
    temp[2] = cryptoData
    SendNUIMessage({type = 'auth', auth = authData})
end)

RegisterNetEvent('quantum_bank:client:registerPlayer')
AddEventHandler('quantum_bank:client:registerPlayer', function()
    quantum_bank['functions'].CreateBlips()
	
	quantum_bank['functions'].startPlayerThread()
	
	if func.isEnabledIncomes() then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(func.getIncomesTime())
				func.payIncomes()
			end
		end)
	end
end)

RegisterNetEvent('quantum_bank:client:triggerAtm')
AddEventHandler('quantum_bank:client:triggerAtm', function(cards)
    if cards['cards'] ~= nil and cards['cards'][1] ~= nil then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed, true)
        for k, v in pairs(quantum_bank['config']['atmModels']) do
            local hash = GetHashKey(v)
            local atm = IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.7)
            if atm then 
                local obj = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 2.0, hash, false, false, false)
                local atmCoords = GetEntityCoords(obj, false)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    type = "atm",
                    atmCards = cards,
					fees = cards['fees']
                })
            end
        end     
    else
        quantum_bank['functions'].Notify(Locales['Nui']['atmNoCards'], "negado")
    end
end)

RegisterNetEvent('quantum_bank:client:triggerWallet')
AddEventHandler('quantum_bank:client:triggerWallet', function(json)
    SetNuiFocus(true, true)
    SendNUIMessage(json)
end)

RegisterNetEvent('quantum_bank:client:refreshNui')
AddEventHandler('quantum_bank:client:refreshNui', function(json, f)
    SendNUIMessage(json)
end)

RegisterCommand('bbnui', function()
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'close'})
end)

RegisterNetEvent("testbank",function(temp,temp2)
	SendNUIMessage({type = 'nui', lang = Locales.Nui, sets = temp})
    SendNUIMessage(temp2)
    TriggerServerEvent('quantum_bank:server:isRegistered')
end)

-- NUI Callbacks
RegisterNUICallback('nuiFocus', function(data)
    SetNuiFocus(data.focus, data.cursor)
end)

RegisterNUICallback('pagarMulta',function(data)
	func.payFines(data.valor, data.multaid)
end)

--[[RegisterNetEvent('quantum_bank:client:startClient')
AddEventHandler('quantum_bank:client:startClient', function(temp, temp2)
    SendNUIMessage({type = 'nui', lang = Locales.Nui, sets = temp})
    SendNUIMessage(temp2)
    TriggerServerEvent('quantum_bank:server:isRegistered')
end)]]

RegisterNUICallback('withdrawEvent', function(data)
    TriggerServerEvent('quantum_bank:server:withdrawEvent', data)
end)

RegisterNUICallback('depositEvent', function(data)
    TriggerServerEvent('quantum_bank:server:depositEvent', data)
end)

RegisterNUICallback('transferEvent', function(data)
    TriggerServerEvent('quantum_bank:server:transferEvent', data)
end)

RegisterNUICallback('changepixEvent', function(data)
	TriggerServerEvent('quantum_bank:server:changePix', data.newPix)
end)

RegisterNUICallback('cardEvent', function(data)
    TriggerServerEvent('quantum_bank:server:cardEvent', data)
end)

RegisterNUICallback('cryptoEvent', function(data)
    TriggerServerEvent('quantum_bank:server:cryptoEvent', data)
end)

RegisterNUICallback('saveSalarys', function(data)
    TriggerServerEvent('quantum_bank:server:saveSalarys', data)
end)

RegisterNUICallback('walletEvent', function(data, cb)
    local selfid = func.getUserId()
    if selfid == tonumber(data.playerid) then
        return cb({status = 'error', message = 'Você não pode ser o alvo.'})
    else
        cb(func.walletEvent(data))
    end
end)

RegisterNUICallback('createSavingAccount', function()
    TriggerServerEvent('quantum_bank:server:createSavingAccount')
end)

RegisterNUICallback('createCard', function(data)
    TriggerServerEvent('quantum_bank:server:createCard', data)
end)