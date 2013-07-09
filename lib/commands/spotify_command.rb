class SpotifyCommand < Flower::Command
  respond_to "play", "pause", "track", "stam", "search", "queue", "playlist", "album", "seek"
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

  def self.respond(message)
    case message.command
    when "pause"
      player.pause
      message.say("Stopped playing")
    when "stam"
      message.say("Stam in da house")
    when "track"
      message.say(get_current_track)
    when "search"
      response = search_tracks(message)
      message.paste(response)
    when "seek"
      seek(message.argument.split(" ").first.to_i)
    when /playlist|album/
      case message.argument.split(" ").first
      when nil
        if current_playlist
          message.paste ["Current playlist", current_playlist.name]
        else
          message.say "No playlist"
        end
      when /shuffle|random/
        if mode = message.argument.split(" ").last
          set_playlist_shuffle(mode)
        end
        message.say("Playlist shuffle is #{playlist_shuffle} (set to \"on\" or \"off\")")
      when 'default'
        playlist = set_playlist(Flower::Config.default_playlist, Flower::Config.bot_nick)
        self.current_playlist = playlist
        message.paste ["Current playlist", current_playlist.name]
      else
        if playlist = set_playlist(message.argument, message.sender[:nick])
          self.current_playlist = playlist
          message.paste ["Current playlist", current_playlist.name]
        end
      end
    when "queue"
      case message.argument
      when nil
        if QUEUE.empty?
          message.say("Queue is empty.")
        else
          message.paste([get_current_track, "Next in queue (#{QUEUE.size})", QUEUE[0, 8].map(&:to_s)])
        end
      when 'clear'
        unless QUEUE.empty?
          QUEUE.reject! { |track| track.requester == message.sender[:nick] }
          message.say "Cleared out all shitty tracks by #{message.sender[:nick]}"
        else
          message.say "Queue is empty."
        end
        post_to_dashboard_upcoming
      else
        if track = get_track(message.argument, message.sender[:nick])
          QUEUE << track
          message.say "Added to queue (#{QUEUE.size}): #{track}"
        end
        post_to_dashboard_upcoming
      end
    when "play"
      case message.argument
      when nil
        player.play
      when "next"
        play_next
      else
        if track = get_track(message.argument, message.sender[:nick])
          play_track(track, message)
        end
      end
      message.say(get_current_track)
    end
  end

  def self.play_next
    player.pause
    if track = (QUEUE.shift || get_next_playlist_track)
      play_track(track)
    end
  end

  def self.description
    "Spotify: \\\"play\\\", \\\"pause\\\", \\\"seek\\\", \\\"track\\\", \\\"search\\\", \\\"queue\\\", \\\"playlist\\\", \\\"album\\\""
  end

  private

  def self.upcoming_track
    next_up = QUEUE.first
    if next_up.nil? && !PLAYLIST.empty?
      next_up = PLAYLIST[playlist_position + 1]
    end
    return next_up
  end

  def self.play_track(track, message = nil)
    self.current_track = track
    Thread.new do
      post_to_dashboard
      begin
        player.play!(track.pointer)
      rescue Hallon::Error => e
        message.say("Flower has error :(   #{e.message}") if message
      end
      play_next
    end
  end

  def self.seek(seconds)
    player.seek(seconds)
    post_to_dashboard(seconds)
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
      post_to_dashboard_upcoming
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

  def self.post_to_dashboard(seek = 0)
    HTTParty.post(Flower::Config.dashboard_widgets_url + "lastfm", body: {
      auth_token: Flower::Config.dashboard_auth_token,
      name:       current_track.name,
      artist:     current_track.artist,
      start:      seek,
      length:     current_track.pointer.duration.to_i,
      image:      "data:image/jpg;base64," + Base64.encode64(current_track.album.cover.load.data)
    }.to_json) rescue nil
    post_to_dashboard_upcoming
  end

  def self.post_to_dashboard_upcoming
    track_name = "No track"
    track_artist = ""
    if upcoming_track.present?
      track_name = upcoming_track.name
      track_artist = upcoming_track.artist
    end
    if upcoming_track.present?
      HTTParty.post(Flower::Config.dashboard_widgets_url + "lastfm", body: {
        auth_token: Flower::Config.dashboard_auth_token,
        upcoming_track_name: upcoming_track.name,
        upcoming_track_artist: upcoming_track.artist,
      }.to_json) rescue nil
    end
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
