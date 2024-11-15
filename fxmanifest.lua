fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Keres & Dév'
description 'Brutal Police Job - store.brutalscripts.com'
version '1.1.1'

data_file 'DLC_ITYP_REQUEST' 'stream/clamp.ytyp'

client_scripts { 
	'config.lua',
	'core/client-core.lua',
	'cl_utils.lua',
	'client/*.lua'
}

server_scripts { 
	'@mysql-async/lib/MySQL.lua', 
	'config.lua',
	'core/server-core.lua',
	'sv_utils.lua',
	'server/*.lua'
}

shared_script {
	'@ox_lib/init.lua'
}

export 'getAvailableCopsCount'
export 'IsHandcuffed'

ui_page "html/index.html"
files {
	"html/index.html",
	"html/style.css",
	"html/script.js",
	"html/assets/*.png",
}

provides { 'esx_policejob', 'brutal_policejob' }

dependencies { 
    '/server:5181',     -- ⚠️PLEASE READ⚠️; Requires at least SERVER build 5181
    '/gameBuild:2189',  -- ⚠️PLEASE READ⚠️; Requires at least GAME build 2189.
}

escrow_ignore {
	'config.lua',
	'sv_utils.lua',
	'cl_utils.lua',
	'core/client-core.lua',
	'core/server-core.lua',
}