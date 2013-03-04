require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  erb :index
end
