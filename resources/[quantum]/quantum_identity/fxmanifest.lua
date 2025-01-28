

fx_version 'bodacious'
game 'gta5'

author 'dnzx & trig'
description 'quantum Identity'
version '0.1'

ui_page "http://26.68.221.155:3006/"
--ui_page "http://26.68.221.155:5173/"
client_script 'client-side/*.lua'
server_script 'server-side/*.lua'
shared_scripts { '@quantum/lib/utils.lua', 'config.lua', '@oxmysql/lib/MySQL.lua' }              
