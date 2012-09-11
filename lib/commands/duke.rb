# encoding: UTF-8
require_relative 'sound_command'
class Boom < SoundCommand
  respond_to "duke"

  FILES = Dir.glob("extras/duke/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Duke Nukem forever!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end