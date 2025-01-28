------------------------------------------------------------------
-- GET HUNGER
------------------------------------------------------------------
quantum.getHunger = function(user_id)
	local data = quantum.getUserDataTable(user_id)
	if (data) then
		return data.hunger
	end
	return 0
end
------------------------------------------------------------------

------------------------------------------------------------------
-- GET THIRST
------------------------------------------------------------------
quantum.getThirst = function(user_id)
	local data = quantum.getUserDataTable(user_id)
	if (data) then
		return data.thirst
	end
	return 0
end
------------------------------------------------------------------

------------------------------------------------------------------
-- VARY HUNGER
------------------------------------------------------------------
quantum.varyHunger = function(user_id, variation)
    local data = quantum.getUserDataTable(user_id)
    if (data and user_id) then
        if (not data.hunger) then 
            data.hunger = 0
        end

        -- Ajuste da fome
        data.hunger = data.hunger + variation
        local overflow = (data.hunger - 100)
        if (overflow > 0) then
            -- Lógica para dano devido ao excesso de fome (comentado no código)
            -- quantumClient._varyHealth(quantum.getUserSource(user_id), (-overflow * config.overflow_damage_factor))
        end

        -- Garantir que a fome esteja no intervalo [0, 100]
        if (data.hunger < 0) then 
            data.hunger = 0
        elseif (data.hunger > 100) then 
            data.hunger = 100 
        end
        
        -- Enviar atualização para o cliente
        TriggerClientEvent('quantum_hud:updateBasics', quantum.getUserSource(user_id), data.hunger, data.thirst)
    end
end

------------------------------------------------------------------

quantum.varyThirst = function(user_id, variation)
    local data = quantum.getUserDataTable(user_id)
    if (data and user_id) then
        if (not data.thirst) then 
            data.thirst = 0
        end

        -- Ajuste da sede
        data.thirst = data.thirst + variation
        local overflow = data.thirst - 100
        if (overflow > 0) then
            -- Lógica para dano devido ao excesso de sede (comentado no código)
            -- quantumClient._varyHealth(quantum.getUserSource(user_id), (-overflow * config.overflow_damage_factor))
        end

        -- Garantir que a sede esteja no intervalo [0, 100]
        if (data.thirst < 0) then 
            data.thirst = 0
        elseif (data.thirst > 100) then 
            data.thirst = 100 
        end
        
        -- Enviar atualização para o cliente
        TriggerClientEvent('quantum_hud:updateBasics', quantum.getUserSource(user_id), data.hunger, data.thirst)
    end
end
------------------------------------------------------------------

stask_update = function()
	for index, value in pairs(cacheUsers.users) do
		quantum.varyHunger(value, config.hunger_per_minute)
		quantum.varyThirst(value, config.thirst_per_minute)
	end
  	SetTimeout(60000, stask_update)
end

async(stask_update)