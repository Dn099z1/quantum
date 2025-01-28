

fx_version 'bodacious'
game 'gta5'

ui_page 'http://26.68.221.155:3003/'
--ui_page 'http://108.165.179.235:5173/'
client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' , 'cfg/Garages.lua' }
shared_scripts { '@quantum/lib/utils.lua', 'main.lua', 'cfg/*.lua' }

data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

files {
	'data/handling.meta',
	'data/vehicles.meta',
	'data/carvariations.meta',
	'ui/**/*.*',
	'ui/*.*'
}

export 'ToggleDisplay'