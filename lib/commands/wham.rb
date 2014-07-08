class Wham < Flower::Command
  respond_to "wham", "WHAM"

  WHAM_URI = "spotify:track:0QPYn15U8IQHKcH2LDfrek"

  def self.description
    'Boom!'
  end

  def self.respond(message)
    if message.command == "WHAM"
      Spotbot.play_track(WHAM_URI)
    else
      Spotbot.queue_track WHAM_URI
    end
    message.say("Hell yeah!")
  end
end
