

fx_version 'bodacious'
game 'gta5'

author 'dnzx & trig'
description 'quantum Dynamic'
version '0.1'

ui_page 'http://26.68.221.155:3002/'
-- ui_page 'http://26.68.221.155:5173/'

exports 'DnzxTablet' 


client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' }
shared_scripts { '@quantum/lib/utils.lua', 'cfg/*.lua' }
