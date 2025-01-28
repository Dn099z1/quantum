

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00 & trig#00'
description 'quantum Shop'
version '0.1'

ui_page 'ui/index.html'

client_script 'module/client.lua'
server_script 'module/server.lua'                                   
shared_scripts { '@quantum/lib/utils.lua', 'config.lua' }

files { 'ui/*' }