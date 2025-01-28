

fx_version 'bodacious'
game 'gta5'

author 'dnzx & trig'
description 'quantum System'
version '0.1'

ui_page 'src/web/index.html'

client_scripts { 'src/libs/PolyZone/*', 'src/libs/NativeUI/NativeUI.lua', 'src/modules/**/client/*' }
server_script 'src/modules/**/server/*'                                   
shared_scripts { '@quantum/lib/utils.lua', 'src/libs/main.lua', 'src/modules/**/config/*' }

files { 'src/web/**/*' }