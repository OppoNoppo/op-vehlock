fx_version 'cerulean'
games { 'gta5' }
author 'OppoNoppo#0226'
description 'op-vehlock | OppoNoppo Vehicle lock'
version '1.2.2'

lua54 'yes'

-- What to run
client_scripts {
    'client/**/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*.lua'
}
