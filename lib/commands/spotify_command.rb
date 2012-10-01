class SpotifyCommand < Flower::Command
  respond_to "play", "pause", "track", "stam", "search"
  require 'appscript'
  require 'hallon'
  require 'hallon-openal'

  def self.respond(command, message, sender, flower)
    case command
    when "pause"
      spotify.pause
      player.pause
      flower.say("Stopped playing")
    when "stam"
      spotify.pause
      flower.say("Stam in da house")
    when "track"
      flower.say(get_current_track)
    when "search"
      response = search(message)
      flower.paste(response)
    when "play"
      case message.split(" ").first
      when nil
        spotify.play
      when "next"
        player.pause
        spotify.play
        spotify.next_track
        flower.say(get_current_track)
      when "prev"
        spotify.previous_track
        sleep 0.2
        spotify.previous_track
        flower.say(get_current_track)
      else
        song = play_song(message)
        flower.say "Playing: #{song}"
      end
    end
  end

  def self.description
    "Spotify: \\\"play next/prev/query\\\", \\\"pause\\\", \\\"track\\\""
  end

  def self.lower_spotify
    100.downto(50) do |i|
      set_volume i
      sleep 0.001
    end
    yield
    50.upto(100) do |i|
      set_volume i
      sleep "0.00#{i}".to_f
    end
  end

  private

  def self.set_volume(volume)
    Appscript::app("Spotify").sound_volume.set volume
  end

  def self.get_current_track
    "Playing: #{spotify.current_track.artist.get} - #{spotify.current_track.name.get}"
  end

  def self.play_song(query)
    if query.match(/^spotify:/)
      track = Hallon::Track.new(query).load
    else
      track = search_for(query).first
    end
    spotify.pause
    Thread.new do
      player.play!(track)
      spotify.play
    end
    "#{track.artist.name} - #{track.name}"
  end

  def self.search(query)
    result = search_for(query)
    response = ["Found #{result.size} tracks:"]
    response << result[0, 5].map{ |track| "#{track.artist.name} - #{track.name} (#{track.to_link.to_uri})" }
  end

  def self.search_for(query)
    Hallon::Search.new(query).load.tracks
  end

  def self.player
    @player ||= Hallon::Player.new(Hallon::OpenAL)
  end

  def self.spotify
    @spotify ||= Appscript::app("Spotify")
  end

  def self.init_session
    @hallon_session ||= hallon_session!
  end

  def self.hallon_session!
    session = Hallon::Session.initialize(IO.read('./spotify_appkey.key'))
    session.login(Flower::Config.spotify_username, Flower::Config.spotify_password)
  rescue
    nil
  end

  init_session
end
