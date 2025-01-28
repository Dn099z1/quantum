local srv = {}
Tunnel.bindInterface('skinShop', srv)



quantum.prepare('quantum_appearance/saveClothes', 'update creation set user_clothes = @user_clothes where user_id = @user_id')
quantum.prepare('quantum_appearance/getClothes', 'select user_clothes from creation where user_id = @user_id')

srv.tryPayment = function(price, customization)
    local _source = source
    local _userId = quantum.getUserId(_source)
    if (_userId) then
        local _sucess = quantum.tryFullPayment(_userId, price)
        if (_sucess) then
            --exports.qbank:extrato(_userId, 'loja de Roupas', -price)
            quantum.execute('quantum_appearance/saveClothes', { user_id = _userId, user_clothes = json.encode(customization) } )
            TriggerClientEvent('notify', _source, 'Loja de Roupas', 'Pagamento <b>efetuado</b> com sucesso!')
        else
            TriggerClientEvent('notify', _source, 'Loja de Roupas', 'Pagamento <b>negado</b>!<br>Saldo <b>insuficiente</b>.')
        end
        return _sucess
    end
end

setCustomization = function(source, user_id)
    local query = quantum.query('quantum_appearance/getClothes', { user_id = user_id })[1]
    if (query) and query.user_clothes then
        quantumClient.setCustomization(source, json.decode(query.user_clothes))
        return true
    end
    print('^5[quantum Appearance]^5 não foi encontrado o user_clothes do USER_ID ^5('..user_id..')^7')
    return false
end
exports('setCustomization', setCustomization)