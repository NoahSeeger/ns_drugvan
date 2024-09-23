fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
} 

server_script {
    'server.lua',
}


client_script {
    'client.lua',
}


files {
    'html/*'
}
