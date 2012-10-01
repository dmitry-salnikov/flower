# encoding: UTF-8
require_relative 'sound_command'
class Rnds < Flower::Command
  respond_to "rnds"

  def self.description
    "Random sound"
  end


  def self.respond(command, message, sender, flower)
    # Pick a randiom class that inherits from SoundCommand and run it
    klass = SoundCommand.subclasses
    r = rand(klass.size)
    klass.at(r).respond(nil, nil, nil, nil)
  end

  private

  def self.store_stats(sender, type)
    Flower::Stats.store("rnds/#{sender[:nick].downcase}", {type => 1})
  end
end
