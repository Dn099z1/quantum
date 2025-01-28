

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00'
description 'quantum Notify Push'
version '0.1'

ui_page 'src/web/index.html'

client_script 'src/module/client.lua'
server_script 'src/module/server.lua'
shared_scripts { '@quantum/lib/utils.lua', 'src/library/shared.lua' }

files { 'src/web/*' }