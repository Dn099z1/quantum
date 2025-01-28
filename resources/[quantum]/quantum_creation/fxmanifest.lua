

fx_version 'bodacious'
game 'gta5'

author 'dnzx#00 & trig#00'
description 'quantum Character'
version '0.1'

--ui_page "http://26.68.221.155:5173"
ui_page "http://26.68.221.155:3001" -- 3001
--ui_page "dist/index.html" 

client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' }
shared_scripts { '@quantum/lib/utils.lua', 'cfg/main.lua', 'cfg/*.lua' }              
