

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00 & trig#00'
description 'Quantum - Homes'
version '0.1'

ui_page 'src/web/index.html'

client_scripts { 'src/module/client-side/*' }
server_scripts { 'src/module/server-side/*' }
shared_scripts { '@quantum/lib/utils.lua', 'src/library/cfg/*.lua' }      

files { 'src/web/*' }
