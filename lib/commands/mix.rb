# encoding: UTF-8
require_relative 'sound_command'
class Mix < SoundCommand
  respond_to "mix"

  def self.description
    "In the mix, play with the music played by the bot!"
  end

  def self.respond(command, message, sender, flower)
    play_file "mix/mix_1.mp3"
  end
end