ENV['SKIP_SPOTIFY'] = "1"
require './lib/flower'
require './web/app'

run Sinatra::Application
