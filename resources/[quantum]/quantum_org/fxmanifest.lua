

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00 & trig#00'
description 'quantum Org'
version '0.1'

ui_page 'http://26.68.221.155:3010/' --3010

client_script 'client/*'
server_script 'server/*'        
shared_scripts { '@quantum/lib/utils.lua', 'main.lua' }