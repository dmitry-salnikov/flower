# encoding: UTF-8
require_relative 'sound_command'
class Dropbomb < SoundCommand
  respond_to "dropbomb"

  def self.description
    "Duck and cover!"
  end

  def self.respond(message)
    play_file("dropbomb/dropbomb1.mp3")
  end
end
