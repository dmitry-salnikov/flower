# encoding: UTF-8
require_relative 'sound_command'
class Greed < SoundCommand
  respond_to "greed"

  FILES = Dir.glob("extras/greed/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Greed!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end