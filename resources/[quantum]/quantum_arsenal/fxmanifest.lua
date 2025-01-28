

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00'
description 'Script de Arsenal'
lua54 'yes'
version '1.0.0'

ui_page 'src/web/index.html'

client_scripts { 'src/module/client/*.lua' }
server_scripts { 'src/module/server/*.lua' }
shared_scripts { '@quantum/lib/utils.lua', 'src/config/*.lua' }
files { 'src/web/*' }          