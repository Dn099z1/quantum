fx_version 'adamant'
game 'gta5'

ui_page "web-side/index.html"

client_scripts {
	"@quantum/lib/utils.lua",
	"client-side/*"
}

server_scripts {
	"@quantum/lib/utils.lua"
}

files {
	"web-side/*",
	"web-side/**/*"
}


                            