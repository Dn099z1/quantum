quantum.prepare('SelectCourseUser', 'select * from courses where user_id = @user_id and course = @course')
quantum.prepare('InsertCourseUser', 'insert ignore into courses (course, user_id, course_type) values (@course, @user_id, @course_type)')
quantum.prepare('DeleteCourseUser', 'delete from courses where user_id = @user_id and course = @course')

local Webhooks = {
    ['add'] = 'dndcwebhook/webhooks/1153178158665830461/7ORy_e2IG8MSDCvSIRrrhaby-Wz9K1IYawy53zwprfbWSO8McFk1mlsCKGkjlOSSPUcV',
    ['rem'] = 'dndcwebhook/webhooks/1153178380347388004/AuaTccnouODQaNcXS5wXZ4CyD1aamIC0_tsHQipsWy_os9yTq-00Fp264SHH8PnsSoYn'
}

local Courses = {
    -- ['cotem'] = { 'policia', 0.1, { '+Policia.TenenteCoronel', '@Staff.COO' } },
    ['cotem'] = { 'policia', 0.1, { '+Staff.COO' } },
}

local Commands = {
    ['add'] = function(source, user_id)
        local prompt = exports.quantum_hud:prompt(source, {
            'ID do Jogador', 'Curso'
        })

        if (not prompt) then return; end;

        local passport, course = parseInt(prompt[1]), string.lower(prompt[2])
        local identity = quantum.getUserIdentity(passport)
        
        if (not Courses[course]) then return TriggerClientEvent('notify', source, 'Cursos', 'Você citou um <b>curso</b> inexistente!'); end;
        if (not quantum.checkPermissions(user_id, Courses[course][3])) then return TriggerClientEvent('notify', source, 'Cursos', 'Você não tem <b>permissão</b>, para realizar esta ação!'); end;
        
        local query = quantum.query('SelectCourseUser', { course = course, user_id = user_id })[1]
        if (not query) then
            quantum.execute('InsertCourseUser', {
                user_id = user_id,
                course = course,
                course_type = Courses[course][1]
            })
            TriggerClientEvent('notify', source, 'Cursos', 'Você deu o curso <b>'..course:upper()..'</b> para o(a) <b>'..identity.firstname..'</b>!')
            local nSource = quantum.getUserSource(passport)
            if (nSource) then TriggerClientEvent('notify', source, 'Cursos', 'Você recebeu o curso <b>'..course:upper()..'</b> parabéns!'); end;

            quantum.webhook(Webhooks.add, '```prolog\n[quantum COURSES]\n[ACTION]: (ADD COURSE)\n[OFFICER]: '..user_id..'\n[TARGET]: '..passport..'\n[COURSE]: '..course..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..'\n```')
        else
            TriggerClientEvent('notify', source, 'Cursos', 'Este cidadão já possui este <b>curso</b>!')
        end
    end,
    ['rem'] = function(source, user_id)
        local prompt = exports.quantum_hud:prompt(source, {
            'ID do Jogador', 'Curso'
        })

        if (not prompt) then return; end;

        local passport, course = parseInt(prompt[1]), string.lower(prompt[2])
        local identity = quantum.getUserIdentity(passport)
        
        if (not Courses[course]) then return TriggerClientEvent('notify', source, 'Cursos', 'Você citou um <b>curso</b> inexistente!'); end;
        if (not quantum.checkPermissions(user_id, Courses[course][3])) then return TriggerClientEvent('notify', source, 'Cursos', 'Você não tem <b>permissão</b>, para realizar esta ação!'); end;

        local query = quantum.query('SelectCourseUser', { course = course, user_id = user_id })[1]
        if (query) then
            quantum.execute('DeleteCourseUser', {
                user_id = user_id,
                course = course
            })
            TriggerClientEvent('notify', source, 'Cursos', 'Você removeu o curso <b>'..course:upper()..'</b> de <b>'..identity.firstname..'</b>!')
            local nSource = quantum.getUserSource(passport)
            if (nSource) then TriggerClientEvent('notify', source, 'Cursos', 'Você perdeu o curso <b>'..course:upper()..'</b>!'); end;

            quantum.webhook(Webhooks.rem, '```prolog\n[quantum COURSES]\n[ACTION]: (REM COURSE)\n[OFFICER]: '..user_id..'\n[TARGET]: '..passport..'\n[COURSE]: '..course..os.date('\n[DATE]: %d/%m/%Y [HOUR]: %H:%M:%S')..'\n```')
        else
            TriggerClientEvent('notify', source, 'Cursos', 'Este cidadão não possui este <b>curso</b>!')
        end
    end,
    ['list'] = function(source, user_id)
        local text = ''
        for k, v in pairs(Courses) do
            text = text..'<br>- <b>'..string.upper(k)..'</b> ('..capitalizeString(v[1])..')'
        end
        TriggerClientEvent('notify', source, 'Cursos', 'Lista de cursos disponíveis: <br>'..text)
    end
}

local hasCourse = function(user_id, course)
    if (user_id and course) then
        local query = quantum.query('SelectCourseUser', { course = course:lower(), user_id = user_id })[1]
        if (query) then
            return true
        end
    end
    return false
end
exports('hasCourse', hasCourse)

RegisterCommand('curso', function(source, args)
    local user_id = quantum.getUserId(source)
    if (args[1]) then
        local args_1 = string.lower(args[1])    
        if (Commands[args_1]) then
            Commands[args_1](source, user_id)
        else
            TriggerClientEvent('notify', source, 'Cursos', 'Você utilizou o comando de forma errada, tente novamente! <br><br><b>- /curso add<br>- /curso rem<br>- /curso list</b>')
        end
    else
        TriggerClientEvent('notify', source, 'Cursos', 'Você utilizou o comando de forma errada, tente novamente! <br><br><b>- /curso add<br>- /curso rem<br>- /curso list</b>')
    end
end)