require 'sinatra'
require 'json'

class WebApp < Sinatra::Base
  attr_reader :flower

  def initialize(flower)
    @flower = flower
    super
  end

  def bang(commands)
    commands.map {|cmd| "!#{cmd}" }
  end

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
    msg.sender = {nick: Flower::Config.bot_nick }

    flower.respond_to(msg)

    redirect '/'
  end

  get '/spotify' do
    erb :spotify
  end

  get '/spotify/track' do
    content_type :json
    { track: SpotifyCommand.current_track.try(:pretty) }.to_json
  end

  post '/spotify/queue' do
    headers 'Access-Control-Allow-Origin' => 'http://localhost:9000',
            'Access-Control-Allow-Methods' => ['POST']
    Flower::SpotifyCommand.add_to_queue params[:uri], 'web'
    ""
  end

  get '/spotify/queue' do
    headers 'Access-Control-Allow-Origin' => 'http://localhost:9000',
            'Access-Control-Allow-Methods' => ['GET']
    content_type :json
    Flower::SpotifyCommand.queue.map(&:pretty).to_json
  end

  post '/spotify/player/play' do
    Flower::SpotifyCommand.play
    ""
  end

  post '/spotify/player/pause' do
    Flower::SpotifyCommand.pause
    ""
  end

  post '/spotify/player/next' do
    Flower::SpotifyCommand.play_next
    ""
  end

  get "/*" do
    # Catch all (favicon etc) to aviod the filling up the log
  end

  private

  def sound_commands
    @sound_commands ||= Flower::COMMANDS.select do |cmd, klass|
      SoundCommand.subclasses.include? klass
    end.keys
  end

  def sound_commands_by_popularity
    sound_commands.sort_by {|cmd| -stats[cmd].to_i }
  end

  def stats
    @stats ||= Flower::Stats.find("commands", 1000.days.ago, 1.hour.from_now).total.select do |cmd, total|
      sound_commands.include?(cmd)
    end
  end
end
