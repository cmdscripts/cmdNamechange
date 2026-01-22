fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/style.css',
  'ui/app.js'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_scripts {
  'client.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server.lua'
}
