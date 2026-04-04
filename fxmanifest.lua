fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Advanced Digging Script for QBCore'
author 'Vilde'
version '1.0.0'


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
