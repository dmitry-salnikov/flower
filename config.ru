$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'flower'
require 'web'

run Sinatra::Application