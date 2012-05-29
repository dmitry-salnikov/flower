# encoding: UTF-8
require_relative 'sound_command'
class Sax < SoundCommand
  respond_to "sax"

  def self.description
    "Epic sax"
  end

  def self.respond(command, message, sender, flower)
    if rand(5) == 1
      play_file "retrosaxguy.m4a"
    else
      play_file "epicsaxguy.m4a"
    end
  end
end