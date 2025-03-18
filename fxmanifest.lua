fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'X SCRIPTS'
version '1.0'
description 'X CHARACTER INFORMATIONS'

files {
    'html/**'
}

ui_page 'html/index.html'

client_script 'client/client.lua'

server_scripts {
'server/server.lua',
'@oxmysql/lib/MySQL.lua'

} 

shared_scripts {
    'config.lua'
}