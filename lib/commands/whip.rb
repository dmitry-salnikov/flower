require_relative 'sound_command'
class Whip < SoundCommand
  respond_to "whip"

  def self.description
    "Feel it!!"
  end

  def self.respond(message)
    play_file("whip/whip.wav")
  end
end
