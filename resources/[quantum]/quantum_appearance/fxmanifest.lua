

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00 & trig#00'
description 'quantum Appearance'
version '0.1'

ui_page 'http://26.68.221.155:3000';
--ui_page 'http://26.68.221.155:5173';

client_scripts { 'client-side/main.lua', 'client-side/*.lua' }
server_scripts { 'server-side/*.lua' }
shared_scripts { '@quantum/lib/utils.lua', 'cfg/*.lua' }              
