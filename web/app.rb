require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  erb :index
end

post '/sound' do
  command = params[:command].gsub(/^!/, '')
  message = params.fetch(:message, "")

  respond(command, message) if sound_commands.include?(command)
  redirect '/'
end

private

def respond(command, message)
  Flower::COMMANDS[command].respond(command, message, sender, flower)
end

def flower
  @flower ||= Flower::Web
end

def sender
  {id: 0, nick: "flower"}
end

def sound_commands
  @sound_commands ||= Flower::COMMANDS.select {|cmd, klass| SoundCommand.subclasses.include? klass}.keys.sort
end

class Flower::Web
  def self.say(message, mention = nil)
  end

  def self.paste(message, mention = nil)
  end
end