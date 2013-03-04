# encoding: UTF-8
require_relative 'sound_command'
class Gott < SoundCommand
  respond_to "gött", "gott"

  def self.description
    "De va la gött!"
  end

  def self.respond(command, message, sender, flower)
    play_file("gott/gott.wav")
  end
end
