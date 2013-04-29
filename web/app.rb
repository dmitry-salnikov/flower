require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  erb :index
end

post '/sound' do
  command = params[:command]

  msg = Flower::Message.new({})
  msg.message = command

  respond(msg) if sound_commands.include?(command)
  redirect '/'
end

private

def respond(message)
  Flower::COMMANDS[message.command].respond(message)
end

def sound_commands
  @sound_commands ||= Flower::COMMANDS.select do |cmd, klass|
    SoundCommand.subclasses.include? klass
  end.keys.sort.map {|cmd| "!#{cmd}"}
end
