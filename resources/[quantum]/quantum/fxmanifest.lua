
fx_version 'bodacious'
game 'gta5'




client_script 'modules/client/*'
server_script 'modules/server/*'
shared_scripts { 'lib/utils.lua', 'quantum.lua', 'configuration/*.lua','@oxmysql/lib/MySQL.lua' }

provide 'vrp'
files { 'lib/*.lua' }              