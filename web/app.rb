require 'sinatra'
require_relative '../lib/flower'

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
  msg.sender = {nick: "webben" }

  if bang(sound_commands).include?(command)
    respond(msg)
    Flower::Stats.store_command_stat(msg)
  end
  redirect '/'
end

get '/spotify' do
  erb :spotify
end

post '/spotify/:uri' do |uri|
end

private

def respond(message)
  Flower::COMMANDS[message.command].respond(message)
end

def sound_commands
  @sound_commands ||= Flower::COMMANDS.select do |cmd, klass|
    SoundCommand.subclasses.include? klass
  end.keys
end

def bang(commands)
  commands.map {|cmd| "!#{cmd}" }
end

def sound_commands_by_popularity
  sound_commands.sort_by {|cmd| -stats[cmd].to_i }
end

def stats
  @stats ||= Flower::Stats.find("commands", 1000.days.ago, 1.hour.from_now).total.select do |cmd, total|
    sound_commands.include?(cmd)
  end
end
