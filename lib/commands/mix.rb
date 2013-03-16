# encoding: UTF-8
require_relative 'sound_command'
class Mix < SoundCommand
  respond_to "mix"

  FILES = Dir.glob("extras/mix/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "In the mix, play with the music played by the bot!"
  end

  def self.respond(message)
    if FILES.include? "mix/#{message.argument}.mp3"
      play_file "mix/#{message.argument}.mp3"
    else
      play_file "mix/mix1.mp3"
    end
  end
end