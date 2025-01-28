srv.clearAfterDie = function()
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
		quantum.RemoveAferDie(user_id, 0)
		quantum.varyThirst(user_id, -100)
		quantum.varyHunger(user_id, -100)

		vRPclient._clearWeapons(source)
		vRPclient._setHandcuffed(source, false)

		quantum.clearInventory(user_id)

		Player(source).state.Capuz = false
		vRPclient.setCapuz(source, false)

		Player(source).state.Handcuff = false
        vRPclient.setHandcuffed(source, false)
		TriggerClientEvent('quantum_interactions:algemas', source)
		return true
    end
	return false
end