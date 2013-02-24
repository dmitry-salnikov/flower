# encoding: UTF-8
require_relative 'sound_command'
class Mix < SoundCommand
  respond_to "mix"

  def self.description
    "In the mix, play with the music played by the bot!"
  end

  def self.respond(command, message, sender, flower)
    if FILES.include? "mix/#{message}.mp3"
      play_file "mix/#{message}.mp3"
    else
      play_file "mix/mix.mp3"
    end
  end
end