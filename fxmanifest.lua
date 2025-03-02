fx_version 'cerulean'
game 'gta5'

description 'Fishing'

author 'NICKO'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',

    '@qbx_core/modules/lib.lua',     -- if you are using qbox make sure this isnt commented out

    'config.lua'
}

server_scripts {
    'server.lua'
}

client_script {
    'client.lua'
}

lua54 'yes'
use_fxv2_oal 'yes'