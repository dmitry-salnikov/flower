# encoding: UTF-8
require_relative 'sound_command'
class Inception < SoundCommand
  respond_to "inception", "bram"

  def self.description
    "BRAAAAMMMM"
  end

  def self.respond(message)
    play_file("inception/inception.mp3")
  end
end
