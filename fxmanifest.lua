fx_version 'cerulean'
game 'gta5'

author 'blanqito'
description 'qb-jobgarage'

shared_script 'config.lua'

server_scripts {
    "server.lua",
    '@oxmysql/lib/MySQL.lua',
}

client_scripts { 
    "client.lua",
}

escrow_ignore {
    'config.lua',  -- Only ignore one file
}

lua54 'yes'