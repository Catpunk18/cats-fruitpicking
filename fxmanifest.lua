fx_version 'cerulean'
game 'gta5'

name 'cats-fruitpicking'
author 'Winter-Cat'
description 'ESX Fruit Harvesting Script'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    '@ox_target/init.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}
