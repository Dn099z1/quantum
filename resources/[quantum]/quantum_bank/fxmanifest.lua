fx_version 'adamant'
game 'gta5'

version '1.0'

client_scripts {
	'@quantum/lib/utils.lua',
    'src/locales/pt-br.lua',
    'src/core/client/client_config.lua',
    'src/core/client/client.lua'
}

server_scripts {
	'@quantum/lib/utils.lua',
    'src/locales/*.lua',
    '@mysql-async/lib/MySQL.lua',
    'src/core/server/server_config.lua',
    'src/core/server/server.lua',
}

server_exports {
    'CreateFine',
    'RegisterNewEntry',
	'ChangePix',
}

ui_page 'src/web/index.html'
files{
    'src/web/img/kredit.ttf',
    'src/web/index.html',
    'src/web/css/style.css',
    'src/web/img/banking.png',
    'src/web/js/script.js',
    'src/web/js/demo/chart-area-demo.js',

    'src/web/vendor/bootstrap/js/bootstrap.bundle.min.js',
    'src/web/vendor/chart.js/Chart.js',
    'src/web/vendor/datatables/dataTables.bootstrap4.js',
    'src/web/vendor/datatables/jquery.dataTables.js',
    'src/web/vendor/jquery/jquery.min.js',
    'src/web/vendor/jquery-easing/jquery.easing.min.js',
    'src/web/vendor/js/src/tools/sanitizer.js',
    'src/web/vendor/js/src/*.js',
	'src/web/vendor/node_modules/popper.js/dist/esm/popper.js',
}