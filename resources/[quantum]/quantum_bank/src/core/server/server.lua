-----------------------------------------------------------------------------------------------------------------------------------------
-- quantum
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("quantum","lib/Tunnel")
local Proxy = module("quantum","lib/Proxy")
quantum = Proxy.getInterface("quantum")

func = {}
Tunnel.bindInterface("ld_bank", func)

vCLIENT = Tunnel.getInterface("ld_bank")

CreditCards = {}
PlayersData = {}

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
		print("\27[0;36m["..GetCurrentResourceName().."]\27[1;33m Script \27[1;31mparado\27[1;33m.")
	end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
		print("\27[0;36m["..GetCurrentResourceName().."]\27[1;33m Script iniciado\27[1;33m.")
	end
end)

quantum_bank['functions'] = {

    GetCharacterName = function(src, identifier)
		local user_id = quantum.getUserId(src)
		local identity = quantum.getUserIdentity(user_id)
		if identity then
			if quantum_bank['config']['base'] == "quantumex" then
				return identity.firstname.." "..identity.lastname
			else
				return identity.firstname.." "..identity.lastname
			end
		else
			return nil
		end 
    end,

    SetCards = function(cards)
        CreditCards = cards
    end,

    SetPlayerData = function(src, data)
        PlayersData[src] = data
    end,

    GetPlayerData = function(src)
        return PlayersData[src]
    end,
}

bbcoinData = {}

function validateConfig()
    if quantum_bank['config']                    and
		quantum_bank['config']['fees']               and
		quantum_bank['config']['startingMoney']      and
		quantum_bank['config']['ATMDaily']           and
		quantum_bank['config']['ATMDailyLimit']      and
		quantum_bank['config']['cryptoPercentage']   and
		quantum_bank['config']['webhooksURL']        and
		quantum_bank['config']['nui']                and
		quantum_bank['config']['nui']['customColor']                and
		quantum_bank['config']['nui']['logo']      then
        return true
    end
    return false
end

--GETTERS PREPARE
quantum.prepare("quantum_bank/get_pix","SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE chavePix = @pix")
quantum.prepare("quantum_bank/get_cards","SELECT * FROM `quantum_bank_cards`")
quantum.prepare("quantum_bank/get_identities","SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE "..quantum_bank['config']['userIdColumn'].." = @user_id LIMIT 1")

--FINES PREPARE
quantum.prepare("quantum_bank/deactivefine","UPDATE `quantum_bank_fines` SET `active` = '0' WHERE `id` = @id")
quantum.prepare("quantum_bank/getfines","SELECT * FROM `quantum_bank_fines` WHERE `pix` = @iban")
quantum.prepare("quantum_bank/getaccount","SELECT * FROM `quantum_bank_accounts` WHERE `identifier` = @iban")
quantum.prepare("quantum_bank/getstatements","SELECT * FROM `quantum_bank_statements` WHERE `pix` = @iban")

--ACCOUNT PREPARES
quantum.prepare("quantum_bank/updateAccount","UPDATE `quantum_bank_accounts` SET `amount` = @amount WHERE `identifier` = @iban AND `type` = @type")
quantum.prepare("quantum_bank/createAccount","INSERT INTO quantum_bank_accounts(`identifier`, `type`, `amount`) VALUES(@identifier,@type,@amount)")
quantum.prepare("quantum_bank/alterPix","UPDATE `"..quantum_bank['config']['pixTable'].."` SET `chavePix` = @pixkey WHERE `"..quantum_bank['config']['userIdColumn'].."` = @user_id")

--PIX PREPARES
quantum.prepare("quantum_bank/change_statements","UPDATE quantum_bank_statements SET pix = @newpix WHERE pix = @oldpix")
quantum.prepare("quantum_bank/change_fines","UPDATE quantum_bank_fines SET pix = @newpix WHERE pix = @oldpix")
quantum.prepare("quantum_bank/change_cards","UPDATE quantum_bank_cards SET identifier = @newpix WHERE identifier = @oldpix")
quantum.prepare("quantum_bank/change_accounts","UPDATE quantum_bank_accounts SET identifier = @newpix WHERE identifier = @oldpix")
quantum.prepare("quantum_bank/change_identities","UPDATE `"..quantum_bank['config']['pixTable'].."` SET chavePix = @newpix WHERE chavePix = @oldpix")

if validateConfig() then
	Citizen.CreateThread(function()
		
		local cards = quantum.query("quantum_bank/get_cards")
		if #cards > 0 then
			if cards then
				for k, v in pairs(cards) do
					v['data'] = json.decode(v['data'])
					v['daily'] = 0
				end
				quantum_bank['functions'].SetCards(cards)
			else
				quantum_bank['functions'].SetCards({})
			end
		end

		if quantum_bank['config']['enableCards'] then
			RegisterCommand('cartoes', function(source, args)
				
				local src = source
				local user_id = quantum.getUserId(src)
				local ply = quantum_bank['functions'].GetPlayerData(src)
				local cards = GetCurrentCards(ply.identifier)
				if cards and #cards > 0 then
					TriggerClientEvent('quantum_bank:client:triggerWallet', src, {
						type =  'wallet',
						wallet = cards,
						iban = ply.iban,
						nui = quantum_bank['config']['nui'],
						cash = quantum.getMoney(user_id)
					})
				else
					TriggerClientEvent("Notify",source,"aviso","Você não possui nenhum cartão.",8000)
				end
			end)
		end

		if quantum_bank['config']['enableATMs'] then
			RegisterCommand('atm', function(source, args)
				
				local src = source
				local id = quantum_bank['functions'].GetPlayerData(src).identifier
				TriggerClientEvent('quantum_bank:client:triggerAtm', src, {
					cards = GetCurrentCards(id),
					nui = quantum_bank['config']['nui'],
					fees = quantum_bank['config']['fees']
				})
			end)
		end

		print('^5[quantum_bank] ^7Atualizando criptomoeda..')
		-- Crypto
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			while true do
				bbcoinData = {}
				bbcoinData['chart'] = {}
				PerformHttpRequest("https://api.coindesk.com/v1/bpi/currentprice.json", function(err, text, headers) 
					if text then
						local data = json.decode(text)
						local pric = data['bpi']['USD']['rate']:gsub(",", "")
						bbcoinData['price'] = tonumber(pric) * quantum_bank['config']['cryptoPercentage']
						if quantum_bank['config']['bitcoinAPI'] == 1 then
							PerformHttpRequest("https://api.coindesk.com/v1/bpi/historical/close.json", function(err, text, headers) 
								if text then
									local data = json.decode(text)
									local rates = data['bpi']
									local chart = bbcoinData['chart']
									for k, v in pairs(rates) do
										local splteddate = SplitStr(k, '-')
										local day = tonumber(splteddate[3])
										local month = tonumber(splteddate[2])
										table.insert(chart, {
											date = {day, month},
											price = tonumber(v) * quantum_bank['config']['cryptoPercentage']
										})
									end
									table.sort(chart, function(a, b)
										if a.date[2] ~= b.date[2] then
											return a.date[2] < b.date[2]
										end
									
										return a.date[1] < b.date[1]
									end)
									print('^5[quantum_bank] ^7Preço do bitcoin atualizado, novo valor: ' .. bbcoinData['price'])
									bbcoinData['presentage'] = ((tonumber(bbcoinData['price']) - tonumber(chart[#chart]['price'])) / tonumber(chart[#chart]['price'])) * 100
									TriggerClientEvent('quantum_bank:client:refreshNui', -1, {
										type = 'crypto',
										crypto = {
											price = bbcoinData['price'],
											presantage = bbcoinData['presentage'],
											chart = bbcoinData['chart']
										}
									})
								end
							end)
						else
							PerformHttpRequest("https://min-api.cryptocompare.com/data/v2/histoday?fsym=BTC&tsym=USD&limit=30&toTs=-1", function(err, text, headers) 
								if text then
									local data = json.decode(text)
									local rates = data['Data']['Data']
									local chart = bbcoinData['chart']
									for k, v in pairs(rates) do
										local splteddate = SplitStr(os.date('%Y-%m-%d', v.time), '-')
										local day = tonumber(splteddate[3])
										local month = tonumber(splteddate[2])
										table.insert(chart, {
											date = {day, month},
											price = tonumber(v.close) * quantum_bank['config']['cryptoPercentage']
										})
									end
									table.sort(chart, function(a, b)
										if a.date[2] ~= b.date[2] then
											return a.date[2] < b.date[2]
										end
									
										return a.date[1] < b.date[1]
									end)
									print('^5[quantum_bank] ^7Preço do bitcoin atualizado, novo valor: ' .. bbcoinData['price'])
									bbcoinData['presentage'] = ((tonumber(bbcoinData['price']) - tonumber(chart[#chart]['price'])) / tonumber(chart[#chart]['price'])) * 100
									TriggerClientEvent('quantum_bank:client:refreshNui', -1, {
										type = 'crypto',
										crypto = {
											price = bbcoinData['price'],
											presantage = bbcoinData['presentage'],
											chart = bbcoinData['chart']
										}
									})
								end
							end)
						end
					end
				end)
				Citizen.Wait(quantum_bank['config']['cryptoUpdateTime']) -- 15 mins
			end
		end)
		
		while not bbcoinData['presentage'] do Wait(0) end
		Citizen.CreateThread(function()
			loadPlayer(-1)
		end) 
	end)
else
	print('^5[quantum_bank] ^7Config inválida!')
end

function loadPlayer(src)
	TriggerClientEvent("testbank",src, {logo = quantum_bank['config']['nui']['logo'], stats = quantum_bank['config']['enableStatements'], color = quantum_bank['config']['nui']['customColor'], multas = quantum_bank['config']['enableFines'], crypto = quantum_bank['config']['enableCrypto']}, {
		type = 'crypto',
		crypto = {
			price = bbcoinData['price'],
			presantage = bbcoinData['presentage'],
			chart = bbcoinData['chart']
		}
	})
end

AddEventHandler(quantum_bank['config']['spawnEvent'],function(user_id,source,first_spawn)
	local source = source
	loadPlayer(source)
end)


function debugMessage(message)
	if quantum_bank['config']['debugMode'] then
		print(message)
	end
end

RegisterServerEvent('quantum_bank:server:isRegistered')
AddEventHandler('quantum_bank:server:isRegistered', function()
	local src = source
	local user_id = quantum.getUserId(src)
	local identifier = user_id
	
	if identifier then
		local res = quantum.query("quantum_bank/get_identities",{ user_id = identifier })
		local iban
		if #res > 0 and res[1] and res[1].chavePix and res[1].chavePix ~= "" then
			iban = res[1].chavePix
		else
			iban = quantum_bank['config'].gerarPIX()
			local consultaPix = quantum.query("quantum_bank/get_pix",{ pix = iban })
			while #consultaPix > 1 do
				iban = quantum_bank['config'].gerarPIX()
				consultaPix = quantum.query("quantum_bank/get_pix",{ pix = iban })
			end

			quantum.execute("quantum_bank/createAccount", { identifier = iban, type = "crypto", amount = 0})
			quantum.execute("quantum_bank/alterPix", { pixkey = iban, user_id = identifier })


			--MySQL.Async.execute("UPDATE `"..quantum_bank['config']['pixTable'].."` SET `chavePix` = '" .. iban .. "' WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. identifier .. "'")
			--MySQL.Async.execute("INSERT INTO `quantum_bank_accounts` (`identifier`, `type`, `amount`) VALUES ('" .. iban .. "', 'crypto', '0')")
			if parseInt(quantum_bank['config']['startingMoney']) > 0 then
				local bank = quantum.getBankMoney(user_id)
				quantum.setBankMoney(user_id,parseInt(bank+parseInt(quantum_bank['config']['startingMoney'])))
				CreateStatment(src, iban, 'GOVERMENT_PAYOUT', 'account', 'deposit', quantum_bank['config']['startingMoney'], 'Bonus de nova conta')
			end
		end

		local playerData = {}
		playerData.identifier = identifier
		local playercharname = quantum_bank['functions'].GetCharacterName(src, identifier)
		if playercharname then
			playerData.name = playercharname
		end
		playerData.iban = iban

		local query = nil

		query = quantum.query("quantum_bank/getfines",{ iban = iban })
		if #query > 0 then playerData.fines = query else playerData.fines = {} end

		query = quantum.query("quantum_bank/getstatements",{ iban = iban })
		if #query > 0 then playerData.stats = query else playerData.stats = {} end

		query = quantum.query("quantum_bank/getaccount",{ iban = iban })
		if #query > 0 then
			local accounts = {}
			for k, v in pairs(query) do
				accounts[v.type] = v
			end
			playerData.accounts = accounts
		else
			playerData.accounts = {}
		end

		quantum_bank['functions'].SetPlayerData(src, playerData)
		TriggerClientEvent('quantum_bank:client:registerPlayer', src)


		if quantum_bank['config']['savingAccount']['enableIncomes'] then
			function func.payIncomes()
				local source = source
				local newData = quantum_bank['functions'].GetPlayerData(src)
				if newData and newData ~= nil then
					if newData['accounts']['saving'] ~= nil then
						local currentBalance = newData['accounts']['saving']['amount']
						local amount = math.floor(newData['accounts']['saving']['amount'] * quantum_bank['config']['savingAccount']['percentage'])
						if amount > 0 then
					
							quantum.execute("quantum_bank/updateAccount",{ amount = (currentBalance + amount), iban = newData['iban'], type = "saving" })
							newData['accounts']['saving']['amount'] = currentBalance + amount

							CreateStatment(source, newData['iban'], 'SAVING_INCOMES', 'saving', 'incomes', amount, 'Rendimento da poupança')
							
							if quantum_bank['config']['savingAccount']['nuiMessage'] then
								TriggerClientEvent("Notify",source,"sucesso","<b>"..tostring(amount).."</b> "..Locales['Server']['sIncomes'],8000)
							end
						end
					end
				end
			end
		end
		--Embed(src, 'INICIALI', "Successfully loaded player", 0)
		debugMessage('^5[quantum_bank] ^7Usuário ^2carregado ^7com sucesso [SRC: '..src..', ID: '..identifier..']')
	else
		debugMessage('^5[quantum_bank] ^1Erro ao carregar jogador SRC: '..src..', user_id nulo')
	end
end)

function func.isEnabledIncomes()
	return quantum_bank['config']['savingAccount']['enableIncomes']
end

function func.getIncomesTime()
	return quantum_bank['config']['savingAccount']['time']
end


function func.getPlayerData()
	local source = source
	return getPlayerData(source)
end

function func.payFines(valorpay, idmulta)
	
	local source = source
	local user_id = quantum.getUserId(source)
	local identity = quantum.getUserIdentity(user_id)

	local value = quantum.getUData(parseInt(user_id),"quantum:fines")
	local multas = json.decode(value) or 0
	local bank = quantum.getBankMoney(user_id)
	
	if user_id then
		if multas < 1 then
			TriggerClientEvent('quantum_bank:client:refreshNui', source, {
				data = getPlayerData(source),
				message = {'error', Locales['Server']['mltNoFoundMessage'], ''},
			})
			TriggerClientEvent("Notify",source,"aviso","Você <b>não possuí</b> multas para pagar.",8000)
		else 
			if bank >= parseInt(valorpay) then
				local playerData = quantum_bank['functions'].GetPlayerData(source)
				
				quantum.setBankMoney(user_id,parseInt(bank-valorpay))
				quantum.setUData(user_id,"quantum:fines",json.encode(parseInt(multas)-parseInt(valorpay)))
				
				quantum.execute("quantum_bank/deactivefine",{ id = idmulta })

				
				local consulta = quantum.query("quantum_bank/getfines",{ iban = GetPIXFromSource(source) })
				if #consulta > 0 then
					playerData.fines = consulta
					quantum_bank['functions'].SetPlayerData(source, playerData)
					Embed(source, 'PAGOU MULTA', "Pagou uma multa de $" .. valorpay, 0)
					TriggerClientEvent('quantum_bank:client:refreshNui', source, {
						data = getPlayerData(source),
						message = {'success', Locales['Server']['mltMessage'], ''},
					})
				end
			else
				TriggerClientEvent('quantum_bank:client:refreshNui', source, {
					data = getPlayerData(source),
					message = {'error', Locales['Server']['Cerrfunds'], ''},
				})
			end
		end
	end
end

RegisterServerEvent('quantum_bank:server:createSavingAccount')
AddEventHandler('quantum_bank:server:createSavingAccount', function()
	
	local src = source
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	--MySQL.Async.execute("INSERT INTO `quantum_bank_accounts` (`identifier`, `type`, `amount`) VALUES ('" .. playerData['iban'] .. "', 'saving', '0')")

	quantum.execute("quantum_bank/createAccount", { identifier = playerData['iban'], type = "saving", amount = 0})

	PlayersData[src]['accounts']['saving'] = {
		id = -1,
		identifier = playerData['iban'],
		type = 'saving',
		amount = 0,
	}
	
	TriggerClientEvent('quantum_bank:client:refreshNui', src, {
		data = getPlayerData(src),
		message = {'success', Locales['Server']['sSavingNew'], ''},
	})
	

	Embed(src, 'CONTA POUPANÇA', "Criou uma nova conta poupança.", 0)
end)

RegisterServerEvent('quantum_bank:server:withdrawEvent')
AddEventHandler('quantum_bank:server:withdrawEvent', function(data)
	
	local src = source
	
	local user_id = quantum.getUserId(src)
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local actionType = data['account']

	if actionType == 'account' then
		local currentBalance = quantum.getBankMoney(user_id)
		local amount = tonumber(data['amount'])
		
		if amount <= currentBalance then
			
			local valor = math.floor(amount * ((100 - quantum_bank['config']['fees']['withdraw']) / 100) )
			
			quantum.setBankMoney(user_id, currentBalance-amount)
			quantum.giveMoney(user_id,valor)
			
			CreateStatment(src, playerData['iban'], 'BANK_WITHDRAW', 'account', 'withdraw', valor, 'Saque bancário')
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'success', tostring(valor) .. Locales['Server']['sWithdrawnS'], ''},
			})

			Embed(src, 'SAQUE', "Sacou com sucesso $" .. amount, 0)
		end
	elseif actionType == 'saving' then
		local currentBalance = playerData['accounts']['saving']['amount']
		local amount = tonumber(data['amount'])
		
		if amount <= currentBalance then
			local bankMoney = quantum.getBankMoney(user_id)
			MySQL.Async.execute("UPDATE `quantum_bank_accounts` SET `amount` = '" .. (currentBalance - amount) .. "' WHERE `identifier` = '" .. playerData['iban'] .. "' AND `type` = 'saving'")
			playerData['accounts']['saving']['amount'] = currentBalance - amount
			quantum.setBankMoney(user_id, bankMoney+amount)
			
			CreateStatment(src, playerData['iban'], 'SAVING_WITHDRAW', 'saving', 'withdraw', amount, 'Saque da poupança (' .. playerData['iban'] .. ")")
			--CreateStatment(src, playerData['iban'], 'BANK_DEPOSIT', 'account', 'deposit', amount, 'Recebido da poupança (' .. playerData['iban'] .. ")")
			
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'success', tostring(amount) .. Locales['Server']['sWithdrawnT'], ''},
			})

			Embed(src, 'SAQUE POUPANÇA', "Sacou com sucesso $" .. amount, 0)
		end
	end
end)

RegisterServerEvent('quantum_bank:server:depositEvent')
AddEventHandler('quantum_bank:server:depositEvent', function(data)
	
	local src = source
	local user_id = quantum.getUserId(src)
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local actionType = data['account']

	if actionType == 'account' then
		local currentCash = quantum.getMoney(user_id)
		local amount = tonumber(data['amount'])
		
		if amount <= currentCash then
			if quantum.tryDeposit(user_id, tonumber(amount)) then
				CreateStatment(src, playerData['iban'], 'FROM_CASH', 'account', 'deposit', amount, 'Depósito bancário')
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'success', tostring(amount) .. Locales['Server']['sDepoT'], ''},
				})

				Embed(src, 'DEPÓSITO', "Depositou com sucesso $" .. amount, 0)
			end
		end
	elseif actionType == 'saving' then
		local currentBalance = quantum.getBankMoney(user_id)
		local currentSaving = playerData['accounts']['saving']['amount']
		local amount = tonumber(data['amount'])
		
		if amount <= currentBalance then

			quantum.setBankMoney(user_id, currentBalance-amount)
			
			quantum.execute("quantum_bank/updateAccount",{ amount = (currentSaving + amount), iban = playerData['iban'], type = "saving" })
			playerData['accounts']['saving']['amount'] = currentSaving + amount
			
			CreateStatment(src, playerData['iban'], 'SAVING_DEPOSIT', 'saving', 'deposit', amount, 'Depósito na poupança (' .. playerData['iban'] .. ")")
			--CreateStatment(src, playerData['iban'], 'BANK_WITHDRAW', 'account', 'withdraw', amount, 'Saving Withdraw From Main Account')
			
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'success', tostring(amount) .. Locales['Server']['sDepoS'], ''},
			})

			Embed(src, 'DEPÓSITO POUPANÇA', "Depositou com sucesso $" .. amount, 0)
		end
	end
end)

function isPixKEY(key)
	quantum.prepare("quantum_bank/pixadapt","SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE chavePix = @chave")
	local result = quantum.query("quantum_bank/pixadapt",{ chave = key })
	return #result > 0
end

RegisterServerEvent('quantum_bank:server:transferEvent')
AddEventHandler('quantum_bank:server:transferEvent', function(data)
	
	local src = source
	
	local user_id = quantum.getUserId(src)
	
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local currentBalance = quantum.getBankMoney(user_id)
	local amount = tonumber(data['amount'])
	
	if currentBalance >= amount then
		local rIban = data['account']
		local rSource = quantum.getUserSource(parseInt(rIban))
		if rSource then
			local rPlayer = rSource
			if rPlayer then
				local rPlayerID = quantum.getUserId(rSource)
				
				if rPlayerID == user_id then
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						data = getPlayerData(src),
						message = {'error', Locales['Server']['sTrans_ERR_SRC'], ''},
					})
					return
				end
				
				local currentBalanceRplayer = quantum.getBankMoney(rPlayerID)
			   
				quantum.setBankMoney(user_id, currentBalance-amount)
				
				
				local valor = math.floor(amount * ((100 - quantum_bank['config']['fees']['transfer']) / 100) )
				
				quantum.setBankMoney(rPlayerID, currentBalanceRplayer+valor)
				
				CreateStatment(src, playerData['iban'], 'BANK_TRANSFER', 'account', 'transfer', amount, 'Transferência para ' .. GetPIXFromSource(rPlayer))
				CreateStatment(rSource, GetPIXFromSource(rPlayer), 'BANK_TRANSFER', 'account', 'transfer', amount, 'Recebido de ID ' .. playerData['iban'])
				
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'success', tostring(amount) .. Locales['Server']['sTransT'] .. GetPIXFromSource(rPlayer), ''},
				})

				Embed(src, 'TRANSFERÊNCIA', "Transferiu $" .. amount .. ' para [Identifier: ' .. rIban .. '] Online', 0)
			else
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'error', Locales['Server']['sTrans_ERR_SRC'], ''},
				})

				Embed(src, 'TRANSFERÊNCIA', "Usuário inválido, tentou transferir $" .. amount .. ' para [Identifier: ' .. rIban .. ']', 1)
			end
		else
			local uuid
			if getIDfromIBANoffline (rIban) ~= nil then
				uuid = getIDfromIBANoffline (rIban)
			else
				uuid = parseInt(rIban)
			end
			if GetIbanFromOfflineSource(uuid) ~= nil then
				MySQL.Async.fetchAll("SELECT * FROM `"..quantum_bank['config']['moneyTable'].."` WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. uuid .. "' LIMIT 1", {}, function(account)
					local rAccountDB = account[1]
					if rAccountDB then
						
						quantum.setBankMoney(user_id, currentBalance-amount)
					   
					   
					   local valor = math.floor(amount * ((100 - quantum_bank['config']['fees']['transfer']) / 100) )
					   
						MySQL.Async.execute("UPDATE `"..quantum_bank['config']['moneyTable'].."` SET `"..quantum_bank['config']['moneyBankColumn'].."` = '" .. (tonumber(account[1].bank) + valor) .. "' WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. uuid .. "'")
						CreateStatment(src, playerData['iban'], 'BANK_TRANSFER', 'account', 'transfer', amount, 'Transferência para ' .. GetIbanFromOfflineSource(uuid))
						CreateStatment(nil, GetIbanFromOfflineSource(uuid), 'BANK_TRANSFER', 'account', 'transfer', amount, 'Recebido de ' .. playerData['iban'])
						TriggerClientEvent('quantum_bank:client:refreshNui', src, {
							data = getPlayerData(src),
							message = {'success', tostring(valor) .. Locales['Server']['sTransT'] .. GetIbanFromOfflineSource(uuid), ''},
						})

						Embed(src, 'TRANSFERÊNCIA', "Transferiu $" .. amount .. ' para [Identifier: ' .. rIban .. '] Offline', 0)
					else
						TriggerClientEvent('quantum_bank:client:refreshNui', src, {
							data = getPlayerData(src),
							message = {'error', Locales['Server']['sTrans_ERR_PIX'], ''},
						})

						Embed(src, 'TRANSFERÊNCIA', "Usuário inválido, tentou transferir $" .. amount .. ' para [Identifier: ' .. rIban .. ']', 1)
					end
				end)
			else
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'error', Locales['Server']['sTrans_ERR_EMPTY'], ''},
				})
			end
		end
	end
end)

RegisterServerEvent('quantum_bank:server:changePix')
AddEventHandler('quantum_bank:server:changePix', function(receive)
	
	local src = source
	
	local user_id = quantum.getUserId(src)
	
	if quantum_bank['config']['pixChangePermission'] ~= nil and not quantum.hasPermission(user_id, quantum_bank['config']['pixChangePermission']) then
		TriggerClientEvent('quantum_bank:client:refreshNui', src, {
			data = getPlayerData(src),
			message = {'error', Locales['Server']['sPIX_NOPERM'], ''},
		})
		return
	end
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local newPix = receive
	newPix = newPix:gsub("%s+", "")
	newPix = string.gsub(newPix, "%s+", "")
	
	local oldPix = playerData['iban']
	ChangePix(oldPix, newPix)
end)

RegisterServerEvent('quantum_bank:server:cryptoEvent')
AddEventHandler('quantum_bank:server:cryptoEvent', function(data)
	
	
	local src = source
	
	local user_id = quantum.getUserId(src)
	
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local currentBalance = quantum.getBankMoney(user_id)
	local amount = tonumber(data['amount'])
	local action = data['event']

	if action == 'buy' then
		if currentBalance >= amount then
			if playerData['accounts']['crypto']['amount'] + (amount / bbcoinData['price']) > quantum_bank['config']['cryptoLimit'] then
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'error', 'Limite de saldo atingido! ('..quantum_bank['config']['cryptoLimit']..')', ''},
				})
				return
			end
			--xPlayer.removeAccountMoney('bank', amount, 'Crypto Buy')
			quantum.setBankMoney(user_id,currentBalance-amount)
			playerData['accounts']['crypto']['amount'] = playerData['accounts']['crypto']['amount'] + (amount / bbcoinData['price'])
			quantum.execute("quantum_bank/updateAccount",{ amount = playerData['accounts']['crypto']['amount'], iban = playerData['iban'], type = "crypto" })
			
			CreateStatment(src, playerData['iban'], 'CRYPTO_BUY', 'crypto', 'buy', (amount / bbcoinData['price']), 'Compra de bitcoins')
			
			
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'success', 'Comprou ' .. (amount / bbcoinData['price']) .. ' BTC', ''},
			})

			Embed(src, 'COMPROU BITCOIN', "Comprou " .. (amount / bbcoinData['price']) .. ' btc [$' .. amount .. ']', 0)
		else 
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'error', 'Dinheiro insuficiente.', ''},
			})
		end
	else
		if playerData['accounts']['crypto']['amount'] * bbcoinData['price'] >= amount then
			--xPlayer.addAccountMoney('bank', amount, 'Crypto Sell')
			quantum.setBankMoney(user_id,currentBalance+amount)
			playerData['accounts']['crypto']['amount'] = playerData['accounts']['crypto']['amount'] - (amount / bbcoinData['price'])
			quantum.execute("quantum_bank/updateAccount",{ amount = playerData['accounts']['crypto']['amount'], iban = playerData['iban'], type = "crypto" })

			CreateStatment(src, playerData['iban'], 'CRYPTO_SELL', 'crypto', 'sell', (amount / bbcoinData['price']), 'Venda de bitcoins')

			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'success', 'Vendeu ' .. (amount / bbcoinData['price']) .. ' BTC', ''},
			})

			

			Embed(src, 'VENDEU BITCOIN', "Vendeu " .. (amount / bbcoinData['price']) .. ' btc [$' .. amount .. ']', 0)
		else
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'error', 'Você não possui tudo isso para vender!', ''},
			})
		end
	end
end)

RegisterServerEvent('quantum_bank:server:cardEvent')
AddEventHandler('quantum_bank:server:cardEvent', function(data)
	
	local src = source
	local user_id = quantum.getUserId(src)
	
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local action = data['action']
	local card = data['card']
	
	local money = quantum.getBankMoney(user_id)

	if action == 'withdraw' then
		local amount = tonumber(data['amount'])
		if amount and amount > 0 and amount <= card['balance'] then
			if card['daily'] + amount < quantum_bank['config']['ATMDailyLimit'] then
				if ActionByIBAN('remove', card['identifier'], amount, 'ATM Withdraw') then
						
					local valor = math.floor(amount * ((100 - quantum_bank['config']['fees']['withdraw']) / 100) )
				
					quantum.giveMoney(user_id,valor)
					local key = IsCardOwner(card['identifier'], card['number'])
					CreditCards[key]['daily'] = CreditCards[key]['daily'] + amount
					Citizen.Wait(200)
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						atmCards = {
							cards = GetCurrentCards(playerData['identifier']),
							nui = quantum_bank['config']['nui'],
							fees = quantum_bank['config']['fees']
						},
						message = {'success', Locales['Server']['sATMWith'] .. amount, 'ATM'},
					})
					CreateStatment(GetSourceFromIban(card['identifier']), card['identifier'], 'BANK_WITHDRAW', 'account', 'withdraw', amount, 'Saque bancário via ATM')
					Embed(GetSourceFromIban(card['identifier']), 'SAQUE ATM', "Sacou $" .. amount.. ' do cartão ' .. card['number'] .. ' \n[Total diário: ' .. CreditCards[key]['daily'] ..'/'..quantum_bank['config']['ATMDailyLimit']..']', 0)
				else
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						atmCards = {
							cards = GetCurrentCards(playerData['identifier']),
							nui = quantum_bank['config']['nui'],
							fees = quantum_bank['config']['fees']
						},
						message = {'error', Locales['Server']['sATM_ERR_PIX'], 'ATM'},
					})
				end
			else
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					atmCards = {
						cards = GetCurrentCards(playerData['identifier']),
						nui = quantum_bank['config']['nui'],
						fees = quantum_bank['config']['fees']
					},
					message = {'error', Locales['Server']['sATM_ERR_LIMIT'], 'ATM'},
				})
			end
		else
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				atmCards = {
					cards = GetCurrentCards(playerData['identifier']),
					nui = quantum_bank['config']['nui'],
					fees = quantum_bank['config']['fees']
				},
				message = {'error', Locales['Server']['sATM_ERR_AMOUNT'], 'ATM'},
			})
		end
	else
		local cardId = IsCardOwner(playerData['iban'], card['number'])
		if cardId then
			if action == 'activate' then
				if CreditCards[cardId]['hold'] == 1 then
					MySQL.Async.execute("UPDATE `quantum_bank_cards` SET `hold` = '0' WHERE `identifier` = '" .. playerData['iban'] .. "' AND `number` = '" .. card['number'] .. "'")
					CreditCards[cardId]['hold'] = 0
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						data = getPlayerData(src),
						message = {'success', Locales['Server']['sCupdated'], ''},
					})
				else
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						data = getPlayerData(src),
						message = {'error', Locales['Server']['sCAalready'], ''},
					})
				end
				return
			elseif action == 'disable' then
				if CreditCards[cardId]['hold'] == 0 then
					MySQL.Async.execute("UPDATE `quantum_bank_cards` SET `hold` = '1' WHERE `identifier` = '" .. playerData['iban'] .. "' AND `number` = '" .. card['number'] .. "'")
					CreditCards[cardId]['hold'] = 1
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						data = getPlayerData(src),
						message = {'success', Locales['Server']['sCupdated'], ''},
					})
				else
					TriggerClientEvent('quantum_bank:client:refreshNui', src, {
						data = getPlayerData(src),
						message = {'error', Locales['Server']['sCDalready'], ''},
					})
				end
				return
			elseif action == 'remove' then
				MySQL.Async.execute("DELETE FROM `quantum_bank_cards` WHERE `identifier` = '" .. playerData['iban'] .. "' AND `number` = '" .. card['number'] .. "'")
				CreditCards[cardId] = nil
				TriggerClientEvent('quantum_bank:client:refreshNui', src, {
					data = getPlayerData(src),
					message = {'success', Locales['Server']['sCRsuccess'], ''},
				})
				return
			end
		else
			TriggerClientEvent('quantum_bank:client:refreshNui', src, {
				data = getPlayerData(src),
				message = {'error', Locales['Server']['sCerr'], ''},
			})
		end
	end
end)

RegisterServerEvent('quantum_bank:server:createCard')
AddEventHandler('quantum_bank:server:createCard', function(data)
	
	local src = source
	local playerData = quantum_bank['functions'].GetPlayerData(src)

	local cardnumber = CreateCardNumber()
	local cardpin = data['pin']
	local carddata = {
		holder = playerData['name'],
		date = math.random(1, 31) ..  '/' .. math.random(1, 12)
	}
	MySQL.Async.execute("INSERT INTO `quantum_bank_cards` (`identifier`, `holder`, `type` , `number`, `pin`, `hold`, `data`) VALUES ('" .. playerData['iban'] .. "', '" .. playerData['identifier'] .. "', 'account','" .. cardnumber .. "', '" .. cardpin .. "', '0', '" .. json.encode(carddata) .. "')")

	table.insert(CreditCards, {
		identifier = playerData['iban'],
		holder = playerData['identifier'],
		type = 'account',
		number = cardnumber,
		pin = cardpin,
		hold = 0,
		data = carddata,
		daily = 0,
	})

	TriggerClientEvent('quantum_bank:client:refreshNui', src, {
		data = getPlayerData(src),
		message = {'success', Locales['Server']['sCardNew'], ''},
	})

	Embed(src, 'CARTÃO DE CRÉDITO', "Criou um novo cartão.", 0)
end)

function func.walletEvent(data)
	local playerSrc = source
	local recSrc = tonumber(data.playerid)
	local player, reciever = quantum.getUserSource(parseInt(playerSrc)), quantum.getUserSource(parseInt(recSrc))
	if data.event == 'cardCheck' then
		if reciever then
			rdata = quantum_bank['functions'].GetPlayerData(reciever).identifier
			MySQL.Async.execute("UPDATE `quantum_bank_cards` SET `holder` = '" .. rdata .. "' WHERE `number` = '" .. data.card.number .. "' AND `identifier` = '" .. data.card.identifier .. "' LIMIT 1")

			for k, v in pairs(CreditCards) do
				if v['identifier'] == data.card.identifier and v['number'] == data.card.number then
					v['holder'] = rdata
				end
			end
			Embed(reciever, 'CARTÃO DE CRÉDITO', 'Deu cartão para o ID ' .. data.playerid  .. '.', 0)
			return {status = 'success', message = Locales['Server']['sCGtoid'] .. data.playerid  .. '.'}
		else
			return {status = 'error', message = Locales['Server']['sCerr']}
		end
	end
end


function func.getUserId()
	local source = source
    local user_id = quantum.getUserId(source)
    return user_id or 0
end

-- Functions
function getPlayerData(src)
	local user_id = quantum.getUserId(src)
	local playerData = {}
	playerData['information'] = quantum_bank['functions'].GetPlayerData(src)

	if not playerData['information']['name'] then
		local name = quantum_bank['functions'].GetCharacterName(src, playerData['information'].identifier)
		if name then
			playerData['information']['name'] = name
		else
			playerData['information']['name'] = "Unknown"
		end
	end

	local chart = { [0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0 }
	playerData.lastdayData = {0, 0}
	if playerData['information'].stats then
		local ctime = os.time()

		for k, v in pairs(playerData['information'].stats) do
			if v.source == 'account' then
				local time = tonumber(v.time)
				
				if math.floor((ctime - time) / 86400) < 8 then
					local space = math.floor((ctime - time) / 86400)

					if v['type'] == 'deposit' then
						chart[space] = chart[space] + v.amount
						if space == 0 then
							playerData.lastdayData[1] = playerData.lastdayData[1] + v.amount
						end
					elseif v['type'] == 'withdraw' then
						chart[space] = chart[space] - v.amount
						if space == 0 then
							playerData.lastdayData[2] = playerData.lastdayData[2] + v.amount
						end
					end
				else
					if v.id ~= nil then
						table.remove(playerData['information'].stats, k)
						MySQL.Async.execute("DELETE FROM `quantum_bank_statements` WHERE `id` = '" .. v.id .. "'")
					end
				end
				
			end
		end
	end
	
	playerData.lastdayDataMlt = {0, 0}
	if playerData['information'].fines then
		local ctime = os.time()

		for k, v in pairs(playerData['information'].fines) do
			if v.source == 'account' then
				local time = tonumber(v.time)
				
				if math.floor((ctime - time) / 86400) < 8 then
					local space = math.floor((ctime - time) / 86400)

					if v['from'] == 'NEW_FINE' then
						if tonumber(v['active']) == 0 then
							chart[space] = chart[space] - v.amount
						end
						if space == 0 then
							playerData.lastdayDataMlt[1] = playerData.lastdayDataMlt[1] + v.amount
						end
					end
				else
					if v.id ~= nil then
						table.remove(playerData['information'].fines, k)
						MySQL.Async.execute("DELETE FROM `quantum_bank_fines` WHERE `id` = '" .. v.id .. "'")
					end
				end
			end
			local value = quantum.getUData(parseInt(user_id),"quantum:fines")
			local multas = json.decode(value) or 0
			playerData.lastdayDataMlt[2] = multas
		end
	end

	playerData.chart = chart
	playerData.fees = quantum_bank['config']['fees']
	playerData.currentAmount = quantum.getBankMoney(user_id)
	playerData.currentCash = quantum.getMoney(user_id)
	playerData.nui = quantum_bank['config']['nui']
	playerData.cards = GetAccountCards(playerData['information']['iban'])
	if bbcoinData['price'] then
		playerData.cryptoData = {
			['amount'] = playerData['information']['accounts']['crypto']['amount'],
			['value'] = playerData['information']['accounts']['crypto']['amount'] * bbcoinData['price'],
		}
	else
		playerData.cryptoData = {
			['amount'] = 0,
			['value'] = 0,
		}
	end
	return playerData
end

quantum.prepare("quantum_bank/createfine","INSERT INTO quantum_bank_fines(`pix`,`from`,`source`,`author`,`amount`,`reason`,`time`,`active`) VALUES(@iban,@from,@source,@author,@amount,@reason,@time,@active)")

function CreateFine(src, author, amount, reason)
	
	
	
	local time = parseInt(os.time())
	quantum.execute("quantum_bank/createfine", { 
		iban = GetPIXFromSource(src),
		from = "NEW_FINE",
		source = "account",
		author = author,
		amount = amount,
		reason = reason,
		time = time,
		active = 1 
	})
	if PlayersData[src] then
		
		local playerData = quantum_bank['functions'].GetPlayerData(src)
		
		local query = quantum.query("quantum_bank/getfines",{ iban = GetPIXFromSource(src) })
		if #query > 0 then playerData.fines = query else playerData.fines = {} end

		quantum_bank['functions'].SetPlayerData(src, playerData)
		return true
	end
	return false
end


quantum.prepare("quantum_bank/createstatement","INSERT INTO `quantum_bank_statements` (`pix`, `from`, `source`, `type`, `amount`, `reason`, `time`) VALUES (@iban, @from, @source, @type, @amount, @reason, @time)")

function CreateStatment(src, iban, from, sourc, typ, amount, reason)
	
	if not iban then iban = GetPIXFromSource(src) end
	local time = parseInt(os.time())
	quantum.execute("quantum_bank/createstatement", { iban = iban, from = from, source = sourc, type = typ, amount = amount, reason = reason, time = time })
	if PlayersData[src] then
		table.insert(PlayersData[src]['stats'], {
			iban = iban,
			from = from,
			source = sourc,
			type = typ,
			amount = amount,
			reason = reason,
			time = time
		})
	end
	return true
end

function RegisterNewEntry(source, type, amount, reason)
	
	local src = source
	local iban = GetPIXFromSource(src)
	if iban ~= nil then
		CreateStatment(src, iban, 'ACTION_API', 'account', type, amount, reason)
	end
end

function ChangePix(oldPix, newPix)
	
	local src = source
	local playerData = quantum_bank['functions'].GetPlayerData(src)
	local existe = false
	
	local consultaPix = quantum.query("quantum_bank/get_pix",{ pix = newPix })
	if #consultaPix > 0 then existe = true end
	if not existe then
		playerData.iban = newPix
		for k,v in pairs(GetAccountCards(oldPix)) do
			v['identifier'] = newPix
		end
		quantum.execute("quantum_bank/change_identities",{ newpix = newPix, oldpix = oldPix })
		quantum.execute("quantum_bank/change_accounts",{ newpix = newPix, oldpix = oldPix })	
		quantum.execute("quantum_bank/change_cards",{ newpix = newPix, oldpix = oldPix })
		quantum.execute("quantum_bank/change_fines",{ newpix = newPix, oldpix = oldPix })
		quantum.execute("quantum_bank/change_statements",{ newpix = newPix, oldpix = oldPix })
		quantum_bank['functions'].SetPlayerData(src, playerData)
		
		TriggerClientEvent('quantum_bank:client:refreshNui', src, {
			data = getPlayerData(src),
			message = {'success', Locales['Server']['sPIX_CHANGED'], ''},
		})
	else
		TriggerClientEvent('quantum_bank:client:refreshNui', src, {
			data = getPlayerData(src),
			message = {'error', Locales['Server']['sEXISTS_PIX'], ''},
		})
	end

end

function GetPIXFromSource(source)
	for k, v in pairs(PlayersData) do
		if k == source then
			return v['iban']
		end
	end
	return nil
end

quantum.prepare("quantum_bank/getofflineiban","SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE `"..quantum_bank['config']['userIdColumn'].."` = @user_id LIMIT 1")
function GetIbanFromOfflineSource(id)
	local query = quantum.query("quantum_bank/getofflineiban",{ user_id = id })
	if query[1] ~= nil then
		return query[1].chavePix
	else
		return nil
	end
end


quantum.prepare("quantum_bank/getidfromofflineiban","SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE `chavePix` = @pixkey LIMIT 1")
function getIDfromIBANoffline(id)
	local acc = quantum.query("quantum_bank/getidfromofflineiban",{ pixkey = id })
	if acc[1] ~= nil then
		return acc[1][quantum_bank['config']['userIdColumn']]
	else
		return nil
	end
end


function GetSourceFromIban(iban)
	for k, v in pairs(PlayersData) do
		if v['iban'] == iban then
			return k
		end
	end
	return nil
end

function CreateCardNumber()
	
	while true do
		local number = math.random(1000, 9999) .. '-' .. math.random(1000, 9999) .. '-' .. math.random(1000, 9999) .. '-' .. math.random(1000, 9999)
		local found = MySQL.Sync.fetchAll("SELECT * FROM `quantum_bank_cards` WHERE `number` = '" .. number .. "' LIMIT 1")
		if found[1] == nil then
			return number
		end
		Wait(0)
	end
end

function GetAccountCards(iban)
	local cards = {}
	for k, v in pairs(CreditCards) do
		if v['identifier'] == iban then
			table.insert(cards, v)
		end
	end
	return cards
end

function GetCurrentCards(id)
	local cards = {}
	for k, v in pairs(CreditCards) do
		if tonumber(v['holder']) == tonumber(id) then
			local balance = ActionByIBAN('get', v['identifier'])
			v['balance'] = balance

			if v['balance'] then
				table.insert(cards, v)
			end
		end
	end
	return cards
end

function IsCardOwner(iban, card)
	for k, v in pairs(CreditCards) do
		if v['identifier'] == iban and v['number'] == card then
			return k
		end
	end
	return nil
end

function SplitStr(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end

function ActionByIBAN(action, iban, amount)
	local src = GetSourceFromIban(iban)
	local rtv = false
	if src then
		local user_id = quantum.getUserId(src)
		if user_id then
			local money = quantum.getBankMoney(user_id)
			if action == 'remove' then
				--xplayer.removeAccountMoney('bank', amount, reason)
				quantum.setBankMoney(user_id,money-amount)
			elseif action == 'add' then
				--xplayer.addAccountMoney('bank', amount, reason)
				quantum.setBankMoney(user_id,money+amount)
			elseif action == 'get' then
				return money
			end
			rtv = true
		end
	end

	if not rtv then
		local acc = MySQL.Sync.fetchAll("SELECT * FROM `"..quantum_bank['config']['pixTable'].."` WHERE `chavePix` = '" .. iban .. "' LIMIT 1")
		
		if acc[1] then
			local target = MySQL.Sync.fetchAll("SELECT * FROM `"..quantum_bank['config']['moneyTable'].."` WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. acc[1][quantum_bank['config']['userIdColumn']] .. "' LIMIT 1")
			local playerTarget = quantum.getUserSource(parseInt(acc[1][quantum_bank['config']['userIdColumn']]))
			if action ~= 'get' then
				if action == 'remove' then
					if playerTarget == nil then
						MySQL.Async.execute("UPDATE `"..quantum_bank['config']['moneyTable'].."` SET `"..quantum_bank['config']['moneyBankColumn'].."` = '" .. (tonumber(target[1].bank) - amount) .. "' WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. acc[1][quantum_bank['config']['userIdColumn']] .. "'")
					else
						local target_id = quantum.getUserId(playerTarget)
						local money = quantum.getBankMoney(target_id)
						quantum.setBankMoney(target_id,money-amount)
					end
				elseif action == 'add' then
					if playerTarget == nil then
						MySQL.Async.execute("UPDATE `"..quantum_bank['config']['moneyTable'].."` SET `"..quantum_bank['config']['moneyBankColumn'].."` = '" .. (tonumber(target[1].bank) + amount) .. "' WHERE `"..quantum_bank['config']['userIdColumn'].."` = '" .. acc[1][quantum_bank['config']['userIdColumn']] .. "'")
					else
						local target_id = quantum.getUserId(playerTarget)
						local money = quantum.getBankMoney(target_id)
						quantum.setBankMoney(target_id,money+amount)
					end
				end
				rtv = true
			else
				return target[1].bank
			end
		end
	end

	return rtv
end

function Embed(src, event, content, color)
	
	local conteudo = "```"..content.."```"
	
	local colors = {
		[0] = "16711935",
	}
	
	local identity = quantum.getUserIdentity(quantum.getUserId(src))


	conteudo = conteudo .. "\n**INFORMAÇÕES DO USUÁRIO:**\n```ini\n"
	conteudo = conteudo .. "[ID]: " .. quantum.getUserId(src) .. "\n"
	if quantum_bank['config']['base'] == "quantumex" then
		conteudo = conteudo .. "[NOME]: " .. identity.firstname.." "..identity.lastname .. "\n"
	else
		conteudo = conteudo .. "[NOME]: " .. identity.firstname.." "..identity.lastname .. "\n"
	end
	
	for k, v in ipairs(GetPlayerIdentifiers(src)) do
		if string.sub(v, 1,string.len("steam:")) == "steam:" then
			conteudo = conteudo .. "[STEAM]: " .. v .. "\n"
		elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
			conteudo = conteudo .. "[IP]: " .. v .. "\n"
		end
	end
	
	conteudo = conteudo .. "```"
	local embed = {
		{
			["color"] = colors[color],
			["title"] = event,
			["description"] = conteudo,
			["footer"] = {
				["text"] = "© Lucca - RebornShop [" .. os.date("%x %X]"),
			},
		}
	}

	PerformHttpRequest(quantum_bank['config']['webhooksURL'], function(err, text, headers) end, 'POST', json.encode({username = 'quantum_bank', embeds = embed}), { ['Content-Type'] = 'application/json' })
end
quantum.prepare('quantum_bank/getMultas', 'select * from quantum_bank_fines where id = @user_id')
verifyMultas = function(user_id)
    if (user_id) then
        local query = quantum.query('quantum_bank/getMultas', { user_id = user_id })
        if (query) then
            local totalValue = 0
            for k, v in ipairs(query) do
                totalValue = (totalValue + v.amount)
            end
            return totalValue
        end
    end
end
exports('verifyMultas', verifyMultas)