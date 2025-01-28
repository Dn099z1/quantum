

fx_version 'bodacious'
game 'gta5'

author 'trig'
description 'quantum Production'
version '0.1'

ui_page "http://26.68.221.155:3008"
-- ui_page "http://26.68.221.155:5173"

client_script 'client.lua'
server_script 'server.lua'
shared_scripts { '@quantum/lib/utils.lua', 'config.lua' }              
