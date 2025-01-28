quantum.getAllMoney = function(user_id)
	local query = quantum.query('quantum_framework/getBankMoney', { user_id = user_id })[1]
	if (query) then
		local wallet = exports.quantum_inventory:getInventoryItemAmount(user_id, 'money')
		local totalValue = 0
		totalValue = parseInt(wallet + query.bank )
		return (totalValue or 0)
	end
	return 0
end
exports('getAllMoney', quantum.getAllMoney)

quantum.getMoney = function(user_id)
	return exports.quantum_inventory:getInventoryItemAmount(user_id, 'money')
end
exports('getMoney', quantum.getMoney)

quantum.getBankMoney = function(user_id)
	local query = quantum.query('quantum_framework/getBankMoney', { user_id = user_id })[1]
	if (query) then
		return (query.bank or 0)
	end
	return 0
end
vRP.getBankMoney = quantum.getBankMoney
exports('getBankMoney', quantum.getBankMoney)


quantum.RemoveAferDie = function(user_id, value)
	local all = exports.quantum_inventory:getInventoryItemAmount(user_id, 'money')
	exports.quantum_inventory:tryGetInventoryItem(user_id, 'money', all)
end
exports('RemoveAferDie', quantum.RemoveAferDie)

quantum.setBankMoney = function(user_id, value)
	quantum.execute('quantum_framework/setBankMoney', { user_id = user_id, bank = value } )
end
vRP.setBankMoney = quantum.setBankMoney

quantum.tryPayment = function(user_id, value)
	local money = quantum.getMoney(user_id)
	if (money >= value) then
		exports.quantum_inventory:tryGetInventoryItem(user_id, 'money', value)
		return true
	end
	return false
end
exports('tryPayment', quantum.tryPayment)

quantum.giveMoney = function(user_id, value)
	if (value > 0) then
		local money = quantum.getMoney(user_id)
		exports.quantum_inventory:giveInventoryItem(user_id, 'money', value)
	end
end
exports('giveMoney', quantum.giveMoney)

quantum.giveBankMoney = function(user_id, value)
	if (value > 0) then
		local money = quantum.getBankMoney(user_id)
		quantum.setBankMoney(user_id, parseInt(money + value))
	end
end
vRP.giveBankMoney = quantum.giveBankMoney
exports('giveBankMoney', quantum.giveBankMoney)


quantum.tryBankPayment = function(user_id, value)
	local money = quantum.getBankMoney(user_id)
	if (money >= value) then
		quantum.setBankMoney(user_id, parseInt(money - value))
		return true
	end
	return false
end
exports('tryBankPayment', quantum.tryBankPayment)


quantum.tryWithdraw = function(user_id, value)
	if (value > 0) then
		local money = quantum.getBankMoney(user_id)
		if (money >= value) then
			quantum.setBankMoney(user_id, parseInt(money - value))
			exports.quantum_inventory:giveInventoryItem(user_id, 'money', value)
			return true
		end
	end
	return false
end
exports('tryWithdraw', quantum.tryWithdraw)

quantum.tryDeposit = function(user_id, value)
	if (value > 0) then
		if quantum.tryPayment(user_id, value) then
			quantum.giveBankMoney(user_id, value)
			return true
		end
	end
	return false
end
exports('tryDeposit', quantum.tryDeposit)

quantum.tryFullPayment = function(user_id, value)
	if (user_id and value) and value >= 0 then
		if (quantum.getMoney(user_id) >= value) then
			return quantum.tryPayment(user_id, value)
		elseif (quantum.getBankMoney(user_id) >= value) then
			return quantum.tryBankPayment(user_id, value)
		else
			if (quantum.getPaypalMoney(user_id) >= value) then
				return quantum.tryPaypalPayment(user_id, value)
			end
		end
	end
	return false
end
exports('tryFullPayment', quantum.tryFullPayment)