class Spotify < Flower::Command
  respond_to "play", "pause", "track", "stam"
  require 'appscript'

  def self.respond(command, message, sender, flower)
    case command
    when "pause"
      spotify.pause
      flower.say("Stopped playing")
    when "stam"
      spotify.pause
      flower.say("Stam in da house")  
    when "track"
      flower.say(get_current_track)
    when "play"
      case message.split(" ").first
      when nil
        spotify.play
      when "next"
        spotify.next_track
      when "prev"
        spotify.previous_track
        sleep 0.2
        spotify.previous_track
      else
        system("osascript -e '#{search_applescript(message)}'")
      end
      flower.say(get_current_track)
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

  def self.spotify
    Appscript::app("Spotify")
  end

  def self.search_applescript(query)
    "
      tell application \"System Events\"
        tell process \"Spotify\"
          tell application \"Spotify\" to activate
          click menu item 17 of menu 1 of menu bar item 4 of menu bar 1
          keystroke \"#{query}\"
          keystroke return
          delay 1
          click menu item 18 of menu 1 of menu bar item 4 of menu bar 1
          key code 53
          keystroke tab
          keystroke tab
          keystroke return
        end tell
        set visible of process \"Spotify\" to false
      end tell
    "
  end
end