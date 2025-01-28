config = {}

config.groups = {
	['Staff'] = {
		information = {
			title = 'quantum Staff',
			groupType = 'staff',
			grades = {
				['Suporte'] = { title = 'Suporte', level = 1 },
				['Moderador'] = { title = 'Moderador', level = 2 },
				['Administrador'] = { title = 'Administrador', level = 3 },
				['Manager'] = { title = 'Manager', level = 4 },
				['COO'] = { title = 'COO', level = 5 },
				['CEO'] = { title = 'CEO', level = 6 }
			}
		},
		'staff.permissao',
		'polpar.permissao',
		'dv.permissao',
		'player.wall',
		'player.noclip'
	},

	['Vips'] = {
		information = {
			title = 'Vips',
			groupType = 'vips',
			grades = {
				['Bronze'] = { title = 'Bronze', level = 1 },
				['Prata'] = { title = 'Prata', level = 2 },
				['Ouro'] = { title = 'Ouro', level = 3 },
				['Rubi'] = { title = 'Rubi', level = 4 },
				['Ametista'] = { title = 'Ametista', level = 5 },
				['Safira'] = { title = 'Safira', level = 6 },
				['Diamante'] = { title = 'Diamante', level = 7 },
				['quantum'] = { title = 'quantum', level = 8 }
			}
		},
		'vip.permissao',
	},
	['Hospital'] = {
		information = { 
			title = 'Centro Médico', 
			groupType = 'job', 
			grades = {
				['Paramedico'] = { title = 'Paramédico', level = 1 },
				['Enfermeiro'] = { title = 'Enfermeiro', level = 2 },
				['Medico'] = { title = 'Médico', level = 3 },
				['Cirurgiao'] = { title = 'Cirurgião', level = 4 },
				['ViceDiretor'] = { title = 'Vice-Diretor', level = 5 },
				['Diretor'] = { title = 'Diretor', level = 6 },
			},
			grades_default = 'Paramedico',
		},
		'hospital.permissao',
		'polpar.permissao'
	},
	
	['Crips'] = {
		information = { 
			title = 'Crips', 
			groupType = 'job', 
			grades = {
				['Membro'] = { title = 'Membro', level = 1 },
				['Gerente'] = { title = 'Gerente', level = 2 },
				['Braço direito'] = { title = 'Vice-Líder', level = 3 },
				['Chefe'] = { title = 'Líder', level = 4 },
			},
			grades_default = 'Membro',
		},
		'crips.permissao',
		'arma.permissao',
		'ilegal.permissao'
	},
	['Groove'] = {
		information = { 
			title = 'Grove Street', 
			groupType = 'job', 
			grades = {
				['Membro'] = { title = 'Membro', level = 1 },
				['Gerente'] = { title = 'Gerente', level = 2 },
				['Braço direito'] = { title = 'Vice-Líder', level = 3 },
				['Chefe'] = { title = 'Líder', level = 4 },
			},
			grades_default = 'Membro',
		},
		'grove.permissao',
		'droga.permissao',
		'ilegal.permissao'
	},
	['Vagos'] = {
		information = { 
			title = 'Vagos', 
			groupType = 'job', 
			grades = {
				['Membro'] = { title = 'Membro', level = 1 },
				['Gerente'] = { title = 'Gerente', level = 2 },
				['Braço direito'] = { title = 'Vice-Líder', level = 3 },
				['Chefe'] = { title = 'Líder', level = 4 },
			},
			grades_default = 'Membro',
		},
		'vagos.permissao',
		'municao.permissao',
		'ilegal.permissao'
	},
	['Ballas'] = {
		information = { 
			title = 'Ballas', 
			groupType = 'job', 
			grades = {
				['Membro'] = { title = 'Membro', level = 1 },
				['Gerente'] = { title = 'Gerente', level = 2 },
				['Braço direito'] = { title = 'Vice-Líder', level = 3 },
				['Chefe'] = { title = 'Líder', level = 4 },
			},
			grades_default = 'Membro',
		},
		'ballas.permissao',
		'lavagem.permissao',
		'ilegal.permissao'
	},

	['Swat'] = {
		information = {
			title = 'SWAT',
			groupType = 'job',
			grades = {
				['Recruit'] = { title = 'Recruta', level = 1 },
				['SWAT Officer'] = { title = 'Policial SWAT', level = 2 },
				['SWAT Specialist'] = { title = 'Especialista SWAT', level = 3 },
				['SWAT Corporal'] = { title = 'Cabo SWAT', level = 4 },
				['SWAT Sergeant'] = { title = 'Sargento SWAT', level = 5 },
				['SWAT Lieutenant'] = { title = 'Tenente SWAT', level = 6 },
				['SWAT Captain'] = { title = 'Capitão SWAT', level = 7 },
				['SWAT Commander'] = { title = 'Comandante SWAT', level = 8 },
				['SWAT Deputy Chief'] = { title = 'Deputado Chefe SWAT', level = 9 },
				['SWAT Chief'] = { title = 'Chefe SWAT', level = 10 },
			},
			grades_default = 'Recruit',
		},
		'swat.permissao',
		'policia.permissao',
	},
	['Interpol'] = {
		information = {
			title = 'Interpol',
			groupType = 'job',
			grades = {
				['Agent'] = { title = 'Agente', level = 1 },
				['Investigator'] = { title = 'Investigador', level = 2 },
				['Special Agent'] = { title = 'Agente Especial', level = 3 },
				['Coordinator'] = { title = 'Coordenador', level = 4 },
				['Chief Investigator'] = { title = 'Chefe de Investigação', level = 5 },
				['Senior Investigator'] = { title = 'Investigador Sênior', level = 6 },
				['Deputy Director'] = { title = 'Diretor Adjunto', level = 7 },
				['Director'] = { title = 'Diretor', level = 8 },
				['Regional Director'] = { title = 'Diretor Regional', level = 9 },
				['Assistant Secretary General'] = { title = 'Secretário-Geral Adjunto', level = 10 },
				['Secretary General'] = { title = 'Secretário-Geral', level = 11 },
				['President'] = { title = 'Presidente', level = 12 },
			},
			grades_default = 'Agent',
		},
		'interpol.permissao',
		'policia.permissao',
	},
	
	['Fbi'] = {
		information = {
			title = 'FBI',
			groupType = 'job',
			grades = {
				['Trainee'] = { title = 'Recruta', level = 1 },
				['Special Agent'] = { title = 'Agente Especial', level = 2 },
				['Senior Special Agent'] = { title = 'Agente Especial Sênior', level = 3 },
				['Supervisory Special Agent'] = { title = 'Agente Especial Supervisor', level = 4 },
				['Assistant Special Agent in Charge'] = { title = 'Assistente de Agente Especial Chefe', level = 5 },
				['Special Agent in Charge'] = { title = 'Agente Especial Chefe', level = 6 },
				['Deputy Assistant Director'] = { title = 'Vice-Diretor Assistente', level = 7 },
				['Assistant Director'] = { title = 'Diretor Assistente', level = 8 },
				['Section Chief'] = { title = 'Chefe de Seção', level = 9 },
				['Deputy Director'] = { title = 'Diretor Adjunto', level = 10 },
				['Director'] = { title = 'Diretor', level = 11 },
				['Executive Assistant Director'] = { title = 'Diretor Assistente Executivo', level = 12 },
				['Deputy Director of National Intelligence'] = { title = 'Diretor Adjunto de Inteligência Nacional', level = 13 },
			},
			grades_default = 'Trainee',
		},
		'fbi.permissao',
		'policia.permissao',
	},
	
	
	['Police'] = {
		information = {
			title = 'Polícia',
			groupType = 'job',
			grades = {
				['Recruit'] = { title = 'Recruta', level = 1 },
				['Officer'] = { title = 'Policial', level = 2 },
				['Detective'] = { title = 'Detetive', level = 3 },
				['Sergeant'] = { title = 'Sargento', level = 4 },
				['Lieutenant'] = { title = 'Tenente', level = 5 },
				['Captain'] = { title = 'Capitão', level = 6 },
				['Commander'] = { title = 'Comandante', level = 7 },
				['Chief of Police'] = { title = 'Chefe de Polícia', level = 8 },
				['Deputy Chief'] = { title = 'Deputado Chefe', level = 9 },
				['Police Commissioner'] = { title = 'Comissário de Polícia', level = 10 },
				['Assistant Chief'] = { title = 'Subchefe de Polícia', level = 11 },
				['Executive Commander'] = { title = 'Comandante Executivo', level = 12 },
				['Superintendent'] = { title = 'Superintendente', level = 13 },
				['Colonel'] = { title = 'Coronel', level = 14 },
				['Chief Executive Officer'] = { title = 'Comandante em Chefe', level = 15 },
				['Police Director'] = { title = 'Diretor de Polícia', level = 16 },
			},
			grades_default = 'Recruit',
		},
		'policia.permissao',
		'polpar.permissao'
	},
}

Tunnel = module('quantum', 'lib/Tunnel')
Proxy = module('quantum', 'lib/Proxy')
quantum = Proxy.getInterface('quantum')