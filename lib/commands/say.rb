# encoding: utf-8
class Say < Flower::Command
  respond_to "say", "whisper", "sing", "säg"

  def self.respond(command, message, sender, flower)
    case command
    when "whisper"
      SpotifyCommand.lower_spotify do
        system "say", "-vwhisper", message
      end
    when "sing"
      SpotifyCommand.lower_spotify do
        system "say", "-vcello", message
      end
    when "say"
      SpotifyCommand.lower_spotify do
        system "say", message
      end
    when "säg"
      voices = %w(Oskar Alva)
      SpotifyCommand.lower_spotify do
        system "say", "-v#{voices.sample}", message
      end
    end
  end

  def self.description
    "Say it with words"
  end
end
