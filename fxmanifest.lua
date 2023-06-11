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
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    "client.lua",
}

escrow_ignore {
    'config.lua',  -- Only ignore one file
}

lua54 'yes'