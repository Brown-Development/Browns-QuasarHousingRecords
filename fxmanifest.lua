fx_version 'bodacious'
author 'Brown Development'
description 'Housing Records for Quasar Housing'
game 'gta5'
lua54 'yes'

client_scripts{
    'code/client.lua'
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'code/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

escrow_ignore {
    'config.lua'
}