class Say < Flower::Command
  respond_to "say", "whisper", "sing"
  
  def self.respond(command, message, sender, flower)
    case command
    when "whisper"
      Spotify.lower_spotify do
        system "say", "-vwhisper", message
      end
    when "sing"
      Spotify.lower_spotify do
        system "say", "-vcello", message
      end
    when "say"
      Spotify.lower_spotify do
        system "say", message
      end
    end
  end

  def self.description
    "Say it with words"
  end
end
