

fx_version 'cerulean'
game 'gta5' 

ui_page 'src/web/index.html'

client_script 'src/module/client.lua'
server_script 'src/module/server.lua'           
shared_scripts { '@quantum/lib/utils.lua', 'src/config.lua' }
files { 'src/web/*' }     