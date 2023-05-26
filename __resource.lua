fx_version 'cerulean'
game 'gta5'
lua54 'yes'

resource_type 'gametype' {name = 'globbymanagement',}

client_scripts {
    'client/*.lua',
}
server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

