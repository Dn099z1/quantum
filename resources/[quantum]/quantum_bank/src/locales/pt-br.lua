Locales = {
    -- NUI
    Nui = {
        -- SIDEBAR NAV
        leftNav = {
            actions = 'Opções',
            savingAccountCont = '<i class="fas fa-fw fa-wallet"></i> Poupança',
			homeCont = 'Página inicial',
            creditCardsCont = '<i class="fab fa-fw fa-cc-visa"></i> Meus cartões',
            cryptoCurrencyCont = "<i class='fab fa-fw fa-bitcoin'></i>Criptomoedas <sup class='text-danger'>NOVO</sup>",
            statisticsCont = 'Estatísticas',
			
			mltCont = 'Multas',
            loggedInTxt = 'Logado como',
        },
		
		popup = {
            toAccess = "Para acessar o",
            bank = 'Banco',
            atm = 'Caixinha'
        },
		
        -- MODALS
        modals = {
            error = 'Erro!',
            success = 'Sucesso!',
            confirm = 'Confirmar',
            cancel = 'Cancelar',
            continue = 'Continuar',

            widtrawModal = {
                header = 'Digite o quanto quer sacar',
                willget = 'Você receberá',
                fees = 'As taxas de saque são',
            },

            depoModal = {
                header = 'Digite o quanto quer depositar',
                willget = 'Você depositará',
            },

            transferModal = {
                header = 'Digite o quanto quer transferir',
                willget = 'Ele receberá',
                fees = 'As taxas de transferência são',
            },
			
			changepixModal = {
                header = 'Digite a nova chave pix',
            },
            
            cryptosModal = {
                header = 'Digite o quanto quer vender (em $)',
                willget = 'Você venderá',
            },
            
            cryptobModal = {
                header = 'Digite o quanto quer comprar (em $)',
                willget = 'Você comprará',
            }
        },
        
        -- PÁGINA INICIAL
        accBalance = 'Seu saldo',
        accRevenueLast = 'Movimentações (Últimas 24 horas)',
        accCards = 'Cartões ativos',
        accRevenue = 'Seu extrato',
        accQActions = 'Ações rápidas',
        Withdraw = 'Sacar',
        Deposit = 'Depositar',
        Transfer = 'Transferir',
        accCrypt = 'Carteira',
        accCryptBalance = 'SALDO:',
        accCryptWaller = 'Minha carteira',

        -- CRIPTOMOEDAS
        cryptPrice = 'PREÇO BITCOIN',
        cryptPriceLast = 'Preço BITCOIN (Últimos 30 dias)',
        cryptBalance = 'SALDO EM BITCOIN',

        -- POUPANÇA 
        svingNoAcc = "Você não possui poupança ainda",
        svingCreate = "Criar uma",
        svingBalance = "Saldo da poupança",
        svingActions = "Ações da poupança",

        -- ESTATÍSTICAS
        stsWithLast = 'Saques (Últimas 24 horas)',
        stsDepoLast = 'Depósitos (Últimas 24 horas)',
        stsHeader = 'Histórico',
        stsTable = {
            'Conta',
            'Source',
            'Ação',
            'Valor',
            'Data',
			'Descrição'
        },
		
		-- muktas
        mlt24Last = 'Total de multas (Últimas 24 horas)',
        mltTotalLast = 'Valor total de multas',
        mltHeader = 'Histórico de multas',
		mltNoFoundMessage = 'Você não possui multas pendentes',
		mltMessage = 'Você pagou uma multa!',
        mltTable = {
            'Conta',
            'Source',
            'Autor',
            'Valor',
            'Data',
			'Descrição'
        },

        -- ATM
        atmEnterPin = 'Digite a senha do cartão [4 dígitos]',
        atmCards = 'Seus cartões',
        atmBalance = 'Saldo atual',
		atmNoCards = 'Você não possui nenhum cartão com você!',

        daysT = 'Dias',
        yesterdayT = 'Ontem',
        todayT = 'Hoje',

        activeC = 'ATIVADO',
        disabledC = 'BLOQUEADO',
        createC = 'CRIAR',
        unknownC = 'DESCONHECIDO',
        confirmC = 'CONFIRMAR',
        Cisdisabled = 'Cartão está desativado',
        Cinvalidpin = 'PIN Inválido',
        Callfields = 'Preencha todos os campos!',
        Cerrfunds = 'Você não possui dinheiro suficiente na conta.',
        Cerrcfunds = 'Você não possui dinheiro suficiente.',
        Cerrcpfunds = 'Você não possui criptomoedas suficientes.',
        Cerreno = 'Sem dinheiro.',
        Cerramount = 'Valor incorreto.',
        Cerrid = 'ID não pode estar vazio!',
    },

    Server = {
	
		sEXISTS_PIX = 'Chave pix já existe!',
		sPIX_CHANGED = 'Chave pix alterada!',
		sPIX_NOPERM = 'Sem permissão.',
		
        sWithdrawnS = '$ sacados da sua conta.',
        sWithdrawnT = '$ sacados para sua conta.',
        sDepoT = '$ depositado na sua conta.',
        sDepoS = '$ depositado na sua poupança',
		sIncomes = ' adicionados a sua poupança (rendimento)',
        sTransT = '$ transferido para ',
        sTrans_ERR_SRC = 'Passaporte inválido.',
        sTrans_ERR_PIX = 'Chave PIX inexistente.',
		sTrans_ERR_EMPTY = 'Usuário não encontrado.',
		
        sCardNew = 'Novo cartão criado!',
		sSavingNew = 'Conta poupança criada!',
    
        sATMWith = 'Você sacou $',
        sATM_ERR_PIX = 'PIX incorreto!',
        sATM_ERR_LIMIT = 'Você atingiu o limite diário.',
        sATM_ERR_AMOUNT = 'Valor incorreto.',

        sCupdated = 'Cartão atualizado.',
        sCAalready = 'O cartão já está ativado!',
        sCDalready = 'O cartão já está desativado!',
        sCRsuccess = 'Cartão excluido',
        sCerr = 'Erro ao executar',
        sCCsuccess = 'Novo cartão criado com sucesso.',
        sCGtoid = 'Você emprestou o cartão para o passaporte ',
    },
	
	-- TEXTO DOS BLIPS (CASO ESTEJAM ATIVOS)
	BlipText = {
        bank = "~y~[E]~w~ Acessar Caixa Eletronico",
        atm = ' ~y~[E]~w~ Acessar Caixa Eletronico ',
    }
}
