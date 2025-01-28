

fx_version "bodacious"
game "gta5"

ui_page "http://26.68.221.155:3005" --3005

client_script {
    "client/*.lua"
}

server_scripts {
    "server/*.lua"
}

shared_scripts {
    "@quantum/lib/utils.lua",
}
