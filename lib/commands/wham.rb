class Wham < Flower::Command
  respond_to "wham", "WHAM"

  WHAM_URI = "spotify:track:0QPYn15U8IQHKcH2LDfrek"

  def self.description
    'Boom!'
  end

  def self.respond(message)
    if message.command == "WHAM"
      track = SpotifyCommand.get_track WHAM_URI, "Billskog"
      SpotifyCommand.play_track(track)
    else
      SpotifyCommand.add_to_queue WHAM_URI, 'Billskog'
    end
    message.say("Hell yeah!")
  end
end
