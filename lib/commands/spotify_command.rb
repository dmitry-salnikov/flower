class SpotifyCommand < Flower::Command
  respond_to "play", "pause", "track", "stam", "search", "queue"
  require 'appscript'
  require 'hallon'
  require 'hallon-openal'

  QUEUE = []

  class << self
    attr_accessor :hallon_track
  end

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
      response = search_tracks(message)
      flower.paste(response)
    when "queue"
      case message.split(" ").first
      when nil
        if QUEUE.empty?
          flower.say("Queue is empty.")
        else
          flower.paste([get_current_track, "Next in queue (#{QUEUE.size})", QUEUE[0, 8].map(&:to_s)])
        end
      else
        track = get_track(message, sender[:nick])
        QUEUE << track
        flower.say "Added to queue (#{QUEUE.size}): #{track}"
      end
    when "play"
      case message.split(" ").first
      when nil
        play_current
      when "next"
        play_next
      when "prev"
        spotify.previous_track
        sleep 0.2
        spotify.previous_track
      else
        track = get_track(message, sender[:nick])
        play_track(track)
      end
      flower.say(get_current_track)
    end
  end

  def self.play_current
    if hallon_track
      player.play
    else
      spotify.play
    end
  end

  def self.play_next
    player.pause
    if track = QUEUE.shift
      play_track(track)
    else
      self.hallon_track = nil
      spotify.play
      spotify.next_track
    end
  end

  def self.description
    "Spotify: \\\"play next/prev\\\", \\\"pause\\\", \\\"track\\\", \\\"search\\\", \\\"queue\\\""
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

  def self.play_track(track)
    spotify.pause
    self.hallon_track = track
    Thread.new do
      player.play!(track.pointer)
      play_next
    end
  end

  def self.get_current_track
    "Playing: ".tap do |message|
      if hallon_track
        message << hallon_track.to_s
      else
        message << "#{spotify.current_track.name.get} - #{spotify.current_track.artist.get}"
      end
    end
  end

  def self.get_track(query, requester = nil)
    if query.match(/^spotify:/)
      match = Hallon::Track.new(query).load
    else
      match = search(query).first
    end
    if match
      Track.new(match, requester)
    end
  end

  def self.search_tracks(query)
    result = search(query)
    response = ["Found #{result.size} tracks:"]
    response << result[0, 8].map{ |track| "#{track.name} - #{track.artist.name} (#{track.to_link.to_uri})" }
  end

  def self.search(query)
    Hallon::Search.new(query).load.tracks
  end

  def self.player
    @@player ||= Hallon::Player.new(Hallon::OpenAL)
  end

  def self.spotify
    @@spotify ||= Appscript::app("Spotify")
  end

  def self.init_session
    @@hallon_session ||= hallon_session!
  end

  def self.hallon_session!
    if appkey = IO.read('./spotify_appkey.key') rescue nil
      session = Hallon::Session.initialize(appkey)
      session.login(Flower::Config.spotify_username, Flower::Config.spotify_password)
      scrobbler = Hallon::Scrobbler.new(:lastfm)
      scrobbler.credentials = [Flower::Config.lastfm_username, Flower::Config.lastfm_password]
      scrobbler.enabled = true
    else
      puts("Warning: No spotify_appkey.key found. Get yours here: https://developer.spotify.com/technologies/libspotify/#application-keys")
    end
  end

  init_session

  class Track < Struct.new(:name, :artist, :pointer, :requester)
    def initialize(track, requester)
      super(track.name, track.artist.name, track, requester)
    end

    def to_s
      CGI.escape "#{name} - #{artist} (#{requester})"
    end
  end
end
