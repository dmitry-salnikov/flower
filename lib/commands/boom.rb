# encoding: UTF-8
require_relative 'sound_command'
class Boom < SoundCommand
  respond_to "boom"

  FILES = Dir.glob("extras/boom/*.wav").map{|f| f.gsub("extras/","")}

  def self.description
    "And boom!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end