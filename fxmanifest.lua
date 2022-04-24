fx_version 'cerulean'
game 'gta5'

description 'Document Forgery Office'
author 'zXn'

version '1.0.0'

shared_scripts {
	'config.lua',
    '@qb-core/shared/locale.lua',
	'locales/*.lua'
}

client_script {
    'client/*.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua',
}

server_script {
    'server/main.lua'
}

lua54 'yes'

dependency 'bob74_ipl'