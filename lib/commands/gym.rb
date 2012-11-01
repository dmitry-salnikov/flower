# encoding: UTF-8
require_relative 'sound_command'
class Gym < SoundCommand
  respond_to "gym"

  FILES = Dir.glob("extras/gym/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "PUMP!"
  end

  def self.respond(command, message, sender, flower)
    if FILES.include? "gym/#{message}.mp3"
      play_file "gym/#{message}.mp3"
    else
      play_file FILES.sample
    end
  end
end