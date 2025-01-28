

fx_version 'bodacious'
game 'gta5'

ui_page 'web-side/index.html'

client_script 'src/module/client.lua'
server_script 'src/module/server.lua'
shared_scripts { '@quantum/lib/utils.lua', 'src/library/*' }

files { 'src/web-side/**/**/*' }