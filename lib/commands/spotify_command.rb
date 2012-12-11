class SpotifyCommand < Flower::Command
  respond_to "play", "pause", "track", "stam", "search", "queue", "playlist", "album"
  require 'appscript'
  require 'hallon'
  require 'hallon-openal'
  require 'httparty'

  QUEUE = []
  PLAYLIST = []

  class << self
    attr_accessor :current_track
    attr_accessor :current_playlist
    attr_accessor :playlist_position
    attr_accessor :playlist_shuffle
  end

  def self.respond(command, message, sender, flower)
    case command
    when "pause"
      player.pause
      flower.say("Stopped playing")
    when "stam"
      flower.say("Stam in da house")
    when "track"
      flower.say(get_current_track)
    when "search"
      response = search_tracks(message)
      flower.paste(response)
    when /playlist|album/
      case message.split(" ").first
      when nil
        if current_playlist
          flower.paste ["Current playlist", current_playlist.name]
        else
          flower.say "No playlist"
        end
      when "shuffle"
        if mode = message.split(" ").last
          set_playlist_shuffle(mode)
        end
        flower.say("Playlist shuffle is #{playlist_shuffle} (set to \"on\" or \"off\")")
      when 'default'
        playlist = set_playlist(Flower::Config.default_playlist, Flower::Config.bot_nick)
        self.current_playlist = playlist
        flower.paste ["Current playlist", current_playlist.name]
      else
        if playlist = set_playlist(message, sender[:nick])
          self.current_playlist = playlist
          flower.paste ["Current playlist", current_playlist.name]
        end
      end
    when "queue"
      case message.split(" ").first
      when nil
        if QUEUE.empty?
          flower.say("Queue is empty.")
        else
          flower.paste([get_current_track, "Next in queue (#{QUEUE.size})", QUEUE[0, 8].map(&:to_s)])
        end
      else
        if track = get_track(message, sender[:nick])
          QUEUE << track
          flower.say "Added to queue (#{QUEUE.size}): #{track}"
        end
      end
    when "play"
      case message.split(" ").first
      when nil
        player.play
      when "next"
        play_next
      else
        if track = get_track(message, sender[:nick])
          play_track(track)
        end
      end
      flower.say(get_current_track)
    end
  end

  def self.play_next
    player.pause
    if track = (QUEUE.shift || get_next_playlist_track)
      play_track(track)
    end
  end

  def self.description
    "Spotify: \\\"play\\\", \\\"pause\\\", \\\"track\\\", \\\"search\\\", \\\"queue\\\", \\\"playlist\\\", \\\"album\\\""
  end

  private

  def self.play_track(track)
    self.current_track = track
    Thread.new do
      post_to_dashboard
      player.play!(track.pointer)
      play_next
    end
  end

  def self.get_current_track
    "Playing: #{current_track}"
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

  def self.set_playlist(query, requester)
    if type = query.match(/^spotify:.*(:playlist|album):/)
      list = List.new(type[1], query, requester)
      PLAYLIST.clear
      self.playlist_position = -1
      list.tracks.each do |track|
        PLAYLIST << track
      end
      list
    end
  end

  def self.get_next_playlist_track
    unless PLAYLIST.empty?
      if playlist_shuffle == "on"
        PLAYLIST.sample
      else
        self.playlist_position += 1
        self.playlist_position = 0 if playlist_position == PLAYLIST.size
        PLAYLIST[playlist_position]
      end
    end
  end

  def self.set_playlist_shuffle(mode)
    return true unless mode == "on" || mode == "off"
    self.playlist_shuffle = mode
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

  def self.init_session
    @@hallon_session ||= hallon_session!
    search("foo") # Do a random search to properly 'init' the Spotify session, and enable the !playlist command.
    self.playlist_shuffle = "off"
  end

  def self.hallon_session!
    if appkey = IO.read(Flower::Config.spotify_appkey) rescue nil
      session = Hallon::Session.initialize(appkey)
      session.login(Flower::Config.spotify_username, Flower::Config.spotify_password)
      scrobbler = Hallon::Scrobbler.new(:lastfm)
      scrobbler.credentials = [Flower::Config.lastfm_username, Flower::Config.lastfm_password]
      scrobbler.enabled = true
    else
      puts("Warning: No spotify_appkey.key found. Get yours here: https://developer.spotify.com/technologies/libspotify/#application-keys")
    end
  end

  def self.post_to_dashboard
    HTTParty.post(Flower::Config.dashboard_widgets_url + "lastfm", body: {
      auth_token: Flower::Config.dashboard_auth_token,
      name:       current_track.name,
      artist:     current_track.artist,
      image:      "data:image/jpg;base64," + Base64.encode64(current_track.album.cover.load.data)
    }.to_json) rescue nil
  end

  init_session

  class Track < Struct.new(:name, :artist, :album, :pointer, :requester)
    def initialize(track, requester)
      super(track.name,
        track.artist.name,
        track.album,
        track,
        requester)
    end

    def to_s
      CGI.escape "#{name} - #{artist} (#{requester})"
    end
  end

  class List < Struct.new(:name, :tracks)
    def initialize(type, spotify_uri, requester)
      if type == "album"
        album = Hallon::Album.new(spotify_uri)
        list = album.browse.load
        name = "#{album.name} - #{album.artist.name}"
      else
        list = Hallon::Playlist.new(spotify_uri).load
        name = list.name
      end
      super(name, list.tracks.map { |track| Track.new(track.load, requester) })
    end
  end
end
