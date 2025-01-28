fx_version 'bodacious'
game 'gta5'



ui_page_preload 'yes'
ui_page 'src/web/index.html'

client_script 'src/module/client.lua'
server_script 'src/module/server.lua'
shared_scripts { '@quantum/lib/utils.lua', 'src/library/*.lua', 'src/module/config.lua' }
files { 'src/web/*' }