# encoding: UTF-8
require_relative 'sound_command'
class Rnds < Flower::Command
  respond_to "rnds"

  def self.description
    "Random sound"
  end


  def self.respond(message)
    klass = SoundCommand.subclasses.sample
    klass.respond(message)
  end
end
