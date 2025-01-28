
local srv = {}
Tunnel.bindInterface('Interactions', srv)
local vCLIENT = Tunnel.getInterface('Interactions')

hasPermPolice = function()
    
end

function srv.ToggleJob(jobName, jobConfig)
    local source = source
    local user_id = quantum.getUserId(source)
    local identity = quantum.getUserIdentity(user_id)
    local inGroup, inGrade = quantum.hasGroup(user_id, jobName)

    if inGroup then
        local newState = not quantum.hasGroupActive(user_id, jobName)
        local groupName = quantum.getGroupTitle(jobName, inGrade)

        quantum.setGroupActive(user_id, jobName, newState)
        local logmsg = ""

        if newState then
            TriggerClientEvent("notify", source, "Toogle", "<b>" .. groupName .. "</b> | Você entrou em serviço.")
            logmsg = "[STATUS]: JOIN"
            if jobConfig.blip then TriggerEvent("sw-blips:tracePlayer", source, jobConfig.blip.name, jobConfig.blip.view) end
        else
            TriggerClientEvent("notify", source, "Toogle", "<b>" .. groupName .. "</b> | Você saiu de serviço.")
            logmsg = "[STATUS]: LEAVE"
            if jobConfig.blip then TriggerEvent("sw-blips:unTracePlayer", source) end
        end

        quantum.webhook((jobConfig.webhook ~= "" and jobConfig.webhook or _ToogleDefault), "```prolog\n[/TOOGLE]\n[JOB]: " .. string.upper(jobName) .. " - " .. string.upper(inGrade) .. "\n[USER]: " .. user_id .. "# " .. identity.firstname .. " " .. identity.lastname .. "\n" .. logmsg .. os.date("\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S") .. " \r```")
    else
        TriggerClientEvent("notify", source, "Toogle", "Você não tem acesso ao trabalho: " .. jobName)
    end
end
