class Spotify < Flower::Command
  respond_to "play", "pause", "track"
  require 'appscript'

  def self.respond(command, message, sender, flower)
    case command
    when "pause"
      spotify.pause
      flower.say("Stoped playing")
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

  private
  def self.get_current_track
    "Playing: #{spotify.current_track.artist.get} - #{spotify.current_track.name.get}"
  end

  def self.spotify
    Appscript::app("Spotify")
  end

  def self.search_applescript(query)
    "
      tell application \"Spotify\" to quit
      tell application \"System Events\"
        tell process \"Spotify\"
          open location \"spotify:search:#{query}\"
          delay 2
          tell application \"Spotify\" to activate
          keystroke tab
          keystroke return
        end tell
        set visible of process \"Spotify\" to false
      end tell
    "
  end
end