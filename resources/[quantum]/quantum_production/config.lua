Proxy = module('quantum', 'lib/Proxy')
Tunnel = module('quantum', 'lib/Tunnel')
quantum = Proxy.getInterface('quantum')

configs = {}

configs.moneyPerFiscal = 100000
configs.governTax = 0.35
configs.governTaxWithBuff = 0.35
configs.blipDistance = 3

configs.products = {
    ['guns'] = {
        -- ['weapon_pistol_mk2'] = { 
        --     order = 1,
        --     name = 'Five-SeveN',
        --     amount = 1,
        --     delay = 10000,
        --     materials = {
        --         ['p-armas'] = { name = 'P. Armas', amount = 21 },
        --     }
        -- },
    },
    ['wammos'] = {
        ['m_weapon_pistol'] = { 
            order = 1,
            name = 'M. 9mm',
            amount = 50,
            delay = 10000,
            materials = {
                ['m-municoes'] = { name = 'M. Munições', amount = 7 },
            }
        },
        ['m_weapon_rifle'] = { 
            order = 2,
            name = 'M. 7.62mm',
            amount = 50,
            delay = 10000,
            materials = {
                ['m-municoes'] = { name = 'M. Munições', amount = 7 },
            }
        },
        ['m_weapon_smg'] = { 
            order = 3,
            name = 'M. 5.56mm',
            amount = 50,
            delay = 10000,
            materials = {
                ['m-municoes'] = { name = 'M. Munições', amount = 7 },
            }
        },
        ['m_weapon_shotgun'] = { 
            order = 4,
            name = 'M. 12 C',
            amount = 50,
            delay = 10000,
            materials = {
                ['m-municoes'] = { name = 'M. Munições', amount = 14 },
            }
        },
    },
    ['mec'] = {
        ['nitro'] = {
            order = 1,
            name = 'Nitro',
            amount = 14,
            delay = 10000,
            materials = {
                ['m-mec'] = { name = 'M. Mecânica', amount = 14 },
            }
        },
        ['kit-reparo'] = {
            order = 1,
            name = 'Kit Reparo',
            amount = 1,
            delay = 10000,
            materials = {
                ['m-mec'] = { name = 'M. Mecânica', amount = 0 },
            }
        }
    },
    ['smuggling'] = {
        ['lockpick'] = {
            order = 1,
            name = 'Lockpick',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 2100 },
            }
        },
        ['keycard'] = {
            order = 2,
            name = 'Keycard',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 1050 },
            }
        },
        ['pendrive'] = {
            order = 3,
            name = 'Pendrive',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 1050 },
            }
        },
        ['c4'] = {
            order = 3,
            name = 'C4',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 1050 },
            }
        },
        ['colete-ilegal'] = {
            order = 5,
            name = 'Colete Ilegal',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 7350 },
            }
        },
        ['adrenalina'] = {
            order = 5,
            name = 'Adrenalina',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 4500 },
            }
        },
        ['weapon_crowbar'] = {
            order = 5,
            name = 'Pé de cabra',
            amount = 1,
            delay = 1000,
            materials = {
                ['dinheirosujo'] = { name = 'Dinheiro Sujo', amount = 1250 },
            }
        },
    },
    ['cook'] = {
        ['combo-camarao'] = {
            order = 1,
            name = 'Camarão de Laurinha',
            amount = 4,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
        ['combo-milho'] = {
            order = 2,
            name = 'Larissa Manuela',
            amount = 4,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
        ['combo-chocolate'] = {
            order = 3,
            name = 'Tudo isso, aceito o desafio',
            amount = 4,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
        ['combo-caviar'] = {
            order = 4,
            name = 'Pra aralho',
            amount = 4,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
        ['energetico'] = {
            order = 5,
            name = 'Energético',
            amount = 2,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
        ['cafe'] = {
            order = 5,
            name = 'Café',
            amount = 2,
            delay = 10000,
            materials = {
                ['c-ingredientes'] = { name = 'C. Ingredientes', amount = 1 },
            }
        },
    },
    ['drugs'] = {
        ['maconha'] = {
            order = 1,
            name = 'Maconha',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
        ['cocaina'] = {
            order = 1,
            name = 'Cocaína',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
        ['metanfetamina'] = {
            order = 1,
            name = 'Metanfetamina',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
    },
    ['lanca'] = {
        ['lanca-perfume'] = {
            order = 1,
            name = 'Lança Perfume',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
    },
    ['maconha'] = {
        ['maconha'] = {
            order = 1,
            name = 'Maconha',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
    },
    ['cocaina'] = {
        ['cocaina'] = {
            order = 1,
            name = 'Cocaína',
            amount = 28,
            delay = 10000,
            materials = {
                ['m-droga'] = { name = 'Material para Drogas', amount = 14 },
            }
        },
    },
    ['hospital'] = {
        ['bandagem'] = {
            order = 1,
            name = 'Bandagem',
            amount = 1,
            delay = 5000,
            materials = {
                ['m-hp'] = { name = 'M. Hospital', amount = 1 },
            }
        },
    }
}

configs.productions = {
    ['hospital'] = {
        label = 'Produção de Hospital', 
        type = 'production',
        coords = vector3(-803.3275, -1205.749, 7.324585),
        products = configs.products.hospital, 
        permission = 'hospital.permissao',
        webhook = 'dndcwebhook/webhooks/1150567600674316358/HAOk-sHKVgALJ-FCxvbuuAEoqn6kdzPLOGROyIgI_ooyYpMAoAQKXf7pyOsbXjYkGgu2'
    },
    ['quantumfome1'] = { 
        type = 'production',
        coords = vector3(-1843.661, -1186.18, 14.30042), 
        label = 'Produção de Alimentos', 
        products = configs.products.cook, 
        permission = 'quantumfome.permissao',
        webhook = 'dndcwebhook/webhooks/1121532883631345834/5G3EmWD3QFjdVtE728_dKZT9wB3Av40XDkuIfUbsooWh1Hql8UrznHgkLomjuIRZ-Qzq' 
    },
    ['smuggling'] = { 
        type = 'shop',
        coords = vector3(1273.358, -1708.391, 54.75684), 
        label = 'Negociações com Contrabandista', 
        products = configs.products.smuggling, 
        webhook = 'dndcwebhook/webhooks/1121532883631345834/5G3EmWD3QFjdVtE728_dKZT9wB3Av40XDkuIfUbsooWh1Hql8UrznHgkLomjuIRZ-Qzq' 
    },

    ['Vagos'] = { 
        type = 'production',
        coords = vector3(0,0,0), 
        label = 'Produção de Munições', 
        buff = true,
        products = configs.products.maconha, 
        permission = 'vagos.permissao',
        webhook = 'dndcwebhook/webhooks/1146572562705432637/JKZuwm-jQS8onvAfxpBzKMF9fDFDRHsmfRbiUx3XpUAMoUktbRqqh65_r0Nt7chbsP8J' 
    },
    ['Groove'] = { 
        type = 'production',
        coords = vector3(-136.4571, -1609.464, 35.02563), 
        label = 'Produção de Munições', 
        buff = true,
        products = configs.products.wammos, 
        permission = 'grove.permissao',
        webhook = 'dndcwebhook/webhooks/1146572562705432637/JKZuwm-jQS8onvAfxpBzKMF9fDFDRHsmfRbiUx3XpUAMoUktbRqqh65_r0Nt7chbsP8J' 
    },
    ['Ballas'] = { 
        type = 'production',
        coords = vector3(0,0,0), 
        label = 'Produção de Munições', 
        buff = true,
        products = configs.products.wammos, 
        permission = 'ballas.permissao',
        webhook = 'dndcwebhook/webhooks/1146572562705432637/JKZuwm-jQS8onvAfxpBzKMF9fDFDRHsmfRbiUx3XpUAMoUktbRqqh65_r0Nt7chbsP8J' 
    },
    ['Crips'] = { 
        type = 'production',
        coords = vector3(0,0,0), 
        label = 'Produção de Munições', 
        buff = true,
        products = configs.products.wammos, 
        permission = 'crips.permissao',
        webhook = 'dndcwebhook/webhooks/1146572562705432637/JKZuwm-jQS8onvAfxpBzKMF9fDFDRHsmfRbiUx3XpUAMoUktbRqqh65_r0Nt7chbsP8J' 
    },
}