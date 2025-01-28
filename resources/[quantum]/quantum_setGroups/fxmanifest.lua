

fx_version 'bodacious'
game 'gta5'

ui_page 'src/web/index.html'

client_script 'src/module/client/client.lua'
server_script 'src/module/server/server.lua'
shared_scripts { '@quantum/lib/utils.lua', 'src/config/*' }

files { 'src/web/*' }                            