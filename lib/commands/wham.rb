class Wham < Flower::Command
  respond_to "wham", "wham!"

  def self.description
    'Boom!'
  end

  def self.respond(message)
    if message.command == "wham!"
      track = SpotifyCommand.get_track "spotify:track:0QPYn15U8IQHKcH2LDfrek", "Billskog"
      SpotifyCommand.play_track(track)
    else
      SpotifyCommand.add_to_queue "spotify:track:0QPYn15U8IQHKcH2LDfrek", 'Billskog'
    end
  end
end
