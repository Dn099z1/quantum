quantum.computeItemsWeight = function(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = quantum.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end
vRP.computeItemsWeight = quantum.computeItemsWeight

quantum.giveInventoryItem = function(user_id,idname,amount)
	if user_id and idname and amount then
		exports.quantum_inventory:giveInventoryItem(user_id, idname, amount)
	end
end
vRP.giveInventoryItem = quantum.giveInventoryItem

quantum.tryGetInventoryItem = function(user_id,idname,amount)
	if user_id and idname and amount then
		if exports.quantum_inventory:tryGetInventoryItem(user_id, idname, amount) then
			return true
		end
	end
	return false
end
vRP.tryGetInventoryItem = quantum.tryGetInventoryItem

quantum.getInventoryItemAmount = function(user_id,idname)
	return exports.quantum_inventory:getInventoryItemAmount(user_id, idname)
end
vRP.getInventoryItemAmount = quantum.getInventoryItemAmount

quantum.getInventory = function(user_id)
	local data = exports.quantum_inventory:getInventory(user_id)
	if data then
		local old_format = {}
		for _,item in pairs(data) do
			if (not old_format[item.index]) then
				old_format[item.index] = { amount = item.amount }
			else
				old_format[item.index].amount = old_format[item.index].amount + item.amount
			end
		end
		return old_format
	end
end
vRP.getInventory = quantum.getInventory

quantum.getInventoryWeight = function(user_id)
	return exports.quantum_inventory:getInventoryWeight(user_id)
end
vRP.getInventoryWeight = quantum.getInventoryWeight

quantum.getInventoryMaxWeight = function(user_id)
    return exports.quantum_inventory:getInventoryMaxWeight(user_id) 
end
vRP.getInventoryMaxWeight = quantum.getInventoryMaxWeight

quantum.setInventoryMaxWeight = function(user_id,max)
    exports.quantum_inventory:setInventoryMaxWeight(user_id, max)
end
vRP.setInventoryMaxWeight = quantum.setInventoryMaxWeight

quantum.varyInventoryMaxWeight = function(user_id,vary)
    local max = quantum.getInventoryMaxWeight(user_id)
    if max then
        quantum.setInventoryMaxWeight(user_id,max+vary)
    end
end
vRP.varyInventoryMaxWeight = quantum.varyInventoryMaxWeight

local clearInventory = 'https://discord.com/api/webhooks/1146465984111202354/cQ6KQ9z8eFjy9Sn6oCYCJLF4pM-RpgIRbQjgas__fhzSGhBYMi2D9A8-oX3vWMq1p7DE'
quantum.clearInventory = function(user_id)
	local source = quantum.getUserSource(user_id)
	if source then
		local items = exports.quantum_inventory:getBag('bag:'..user_id)
		local maxWeight = quantum.getInventoryMaxWeight(user_id)
		local Alianca = (quantum.getInventoryItemAmount(user_id, 'alianca-casamento') > 0)

		exports.quantum_inventory:clearInventory(user_id)

		if (Alianca) then quantum.giveInventoryItem(user_id, 'alianca-casamento', 1); end;
		
		if (not quantum.hasPermission(user_id, '+Vips.Ouro')) then
			quantum.setInventoryMaxWeight(user_id, 6)
		else
			local bag = quantum.query('quantum_inventory:getBag', { bag_type = 'bag:'..user_id })[1]
			if (not bag) then
				quantum.execute('quantum_inventory:insertBag', { slots = json.encode({}), bag_type = 'bag:'..user_id, weight = maxWeight })
				quantum.execute('quantum_inventory:insertBag', { slots = json.encode({}), bag_type = 'hotbar:'..user_id, weight = 0 })
			else
				quantum.setInventoryMaxWeight(user_id, maxWeight)
			end
		end		

		quantum.webhook(clearInventory, '```prolog\n[CLEAR INVENTORY]\n[USER_ID]: '..user_id..'\n[ITEMS]: '..json.encode(items, { indent = true })..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
	end
end
vRP.clearInventory = quantum.clearInventory

quantum.itemBodyList = function(item)
	return exports.quantum_inventory:getItemInfo(item) or {}
end
vRP.itemBodyList = quantum.itemBodyList

quantum.itemExists = function(item)
	return (quantum.itemBodyList(item).name ~= nil)
end
vRP.itemExists = quantum.itemExists

quantum.itemNameList = function(item)
	return quantum.itemBodyList(item).name
end
vRP.itemNameList = quantum.itemNameList

quantum.itemIndexList = function(item)
	return item
end
vRP.itemIndexList = quantum.itemIndexList

quantum.itemTypeList = function(item)
	return quantum.itemBodyList(item).type
end
vRP.itemTypeList = quantum.itemTypeList

quantum.getItemWeight = function(item)
	return (quantum.itemBodyList(item).weight or 0)
end
vRP.getItemWeight = quantum.getItemWeight

quantum.getItemDefinition = function(item)
    local data = quantum.itemBodyList(item)
	return data.name,(data.weight or 0)
end
vRP.getItemDefinition = quantum.getItemDefinition