

fx_version 'bodacious'
game 'gta5'

client_scripts { 'src/module/client-side/general/*','src/module/client-side/misc/*'}
server_scripts { 'src/module/server-side/general/*', 'src/module/server-side/misc/*' }                                                        
shared_scripts { '@quantum/lib/utils.lua','@oxmysql/lib/MySQL.lua', 'src/library/lib.lua', 'src/configuration/*' }


server_exports {
    'casar'
}

exports {
    'quantum_core_CHANGE_TEMP_WHHITELIST',
    'quantum_core_CHECK_TEMP_WHITELIST',
    'quantum_core_ACTION'
}

-- Server-specific Exports
server_exports {
    'quantum_core_CHANGE_TEMP_WHHITELIST',
    'quantum_core_CHECK_TEMP_WHITELIST',
    'quantum_core_ACTION'
}

