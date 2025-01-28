config = {}

config.roles = {
    ilegal = { full_permissions = {'Chefe', 'Braço direito'}, half_permissions = 'Gerente' },
    police = { full_permissions = { 'Colonel', 'Chief Executive Officer', 'Police Director' }, half_permissions = { 'Commander' } },
    swat = { full_permissions = { 'Chief', 'Deputy Chief' }, half_permissions = { 'Commander', 'Captain' } },
    interpol = { full_permissions = { 'President', 'Secretary General' }, half_permissions = { 'Regional Director', 'Director' } },
    fbi = { full_permissions = { 'Deputy Director of National Intelligence', 'Director' }, half_permissions = { 'Assistant Director', 'Section Chief' } },
    hospital = { full_permissions = 'Diretor', half_permissions = 'Supervisor' },
    mecanica = { full_permissions = { 'Lider', 'ViceLider' }, half_permissions = 'Gerente' },
    restaurante = { full_permissions = { 'Dono', 'Socio' }, half_permissions = 'Gerente' },
    judiciario = { full_permissions = 'Presidente', half_permissions = 'VicePresidente' },
}

config.grades = {
    ilegal = {
        'Chefe',
        'Braço direito',
        'Gerente',
        'Membro'
    },
    swat = {
        'Recruit',
        'Officer',
        'Specialist',
        'Corporal',
        'Sergeant',
        'Lieutenant',
        'Captain',
        'Commander',
        'Deputy Chief',
        'Chief'
    },
    interpol = {
        'Agent',
        'Investigator',
        'Special Agent',
        'Coordinator',
        'Chief Investigator',
        'Senior Investigator',
        'Deputy Director',
        'Director',
        'Regional Director',
        'Assistant Secretary General',
        'Secretary General',
        'President'
    },
    fbi = {
        'Trainee',
        'Special Agent',
        'Senior Special Agent',
        'Supervisory Special Agent',
        'Assistant Special Agent in Charge',
        'Special Agent in Charge',
        'Deputy Assistant Director',
        'Assistant Director',
        'Section Chief',
        'Deputy Director',
        'Director',
        'Executive Assistant Director',
        'Deputy Director of National Intelligence'
    },
    police = {
        'Recruit',
        'Officer',
        'Detective',
        'Sergeant',
        'Lieutenant',
        'Captain',
        'Commander',
        'Chief of Police',
        'Deputy Chief',
        'Police Commissioner',
        'Assistant Chief',
        'Executive Commander',
        'Superintendent',
        'Colonel',
        'Chief Executive Officer',
        'Police Director'
    },
    hospital = {
        'Diretor',
        'Supervisor',
        'Medico',
        'Pediatra',
        'Paramedico',
        'Enfermeiro'
    },
    mecanica = {
        'Lider',
        'ViceLider',
        'Gerente',
        'Supervisor',
        'Funileiro',
        'Mecanico',
        'AuxMecanico',
    },
    restaurante  = {
        'Dono',
        'Socio',
        'Gerente',
        'Cozinheiro',
        'Atendente',
        'Entregador',
        'Novato',
    },
    judiciario = {
        'Presidente',
        'VicePresidente',
        'SecretarioGeral',
        'SecretarioAdjunto',
        'AdvogadoSenior',
        'AdvogadoPleno',
        'AdvogadoJunior',
        'ChefeSeguranca',
        'Seguranca',
        'Estagiario',
    },
}

config.organizations = {
    --==========================================================================

    ['Police'] = {
        vagas = 500,
        serviceCheck = 'active',
        grades = config.grades.police,
        roles = config.roles.police
    },
    ['Swat'] = {
        vagas = 100,
        serviceCheck = 'active',
        grades = config.grades.swat,
        roles = config.roles.swat
    },
    ['Interpol'] = {
        vagas = 100,
        serviceCheck = 'active',
        grades = config.grades.interpol,
        roles = config.roles.interpol
    },
    ['Fbi'] = {
        vagas = 100,
        serviceCheck = 'active',
        grades = config.grades.fbi,
        roles = config.roles.fbi
    },
    ['Juridico'] = {
        vagas = 500,
        serviceCheck = 'online',
        grades = config.grades.judiciario,
        roles = config.roles.judiciario
    },
    ['Deic'] = {
        vagas = 500,
        serviceCheck = 'active',
        grades = config.grades.deic,
        roles = config.roles.deic
    },
    ['Hospital'] = {
        vagas = 500,
        serviceCheck = 'active',
        grades = config.grades.hospital,
        roles = config.roles.hospital
    },
    ['New Hunger'] = {
        vagas = 500,
        serviceCheck = 'active',
        grades = config.grades.restaurante,
        roles = config.roles.restaurante
    },
    ['New Mechanic'] = {
        vagas = 500,
        serviceCheck = 'active',
        grades = config.grades.mecanica,
        roles = config.roles.mecanica
    },
    ['Crips'] = {
        vagas = 30,
        serviceCheck = 'online',
        grades = config.grades.ilegal,
        roles = config.roles.ilegal
    },
    ['Groove'] = {
        vagas = 30,
        serviceCheck = 'online',
        grades = config.grades.ilegal,
        roles = config.roles.ilegal
    },
    ['Ballas'] = {
        vagas = 30,
        serviceCheck = 'online',
        grades = config.grades.ilegal,
        roles = config.roles.ilegal
    },
    ['Vagos'] = {
        vagas = 20,
        serviceCheck = 'online',
        grades = config.grades.ilegal,
        roles = config.roles.ilegal
    },
}
