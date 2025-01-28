local shootingWebhook = 'dndcwebhook/webhooks/1147712991643582474/ESs65wF2eSWa-N855upmTxOj-UBoo8sFV7x3155-jHmGTodkpy36lDzmTH-msNA6LFw8'

RegisterNetEvent('quantum_core:shoting', function(coord)
    local source = source
    local user_id = quantum.getUserId(source)
    if (user_id) then
        quantum.webhook(shootingWebhook, '```prolog\n[DISPAROS]\n[USER]: '..user_id..'\n[COORD]: '..tostring(coord)..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..' \r```')
        if (GetPlayerRoutingBucket(source) ~= 0) then return; end;
        if (quantum.checkPermissions(user_id, { 'policia.permissao', 'staff.permissao', 'attachs2.permissao' })) then return; end;

        local police = quantum.getUsersByPermission('policia.permissao')
        for k, v in pairs(police) do
            local nSource = quantum.getUserSource(parseInt(v))
            if (nSource) then
                async(function()
                    TriggerClientEvent('notifypush', nSource, {
                        code = 'QRU',
                        title = 'Disparos de arma de fogo',
                        description = 'Denúncia Anônima',
                        coords = coord
                    })
                    TriggerClientEvent('quantum_core:shotingBlip', nSource, coord, user_id)
                end)
            end
        end
    end
end)