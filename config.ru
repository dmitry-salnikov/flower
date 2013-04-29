ENV['SKIP_SPOTIFY'] = "1"
require './lib/flower'
require './lib/message'
require './web/app'

run Sinatra::Application
