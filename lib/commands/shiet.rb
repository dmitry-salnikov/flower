# encoding: UTF-8
require_relative 'sound_command'
class Shiet < SoundCommand
  respond_to "shiet"

  FILES = Dir.glob("extras/shiet/*.wav").map{|f| f.gsub("extras/","")}

  def self.description
    "Shiiiiiiiiiiiiiieeeeeeeeeet!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end