require 'redistat'

class Flower::Stats
  include Redistat::Model

  def self.store_command_stat(command, nick)
    Flower::Stats.store("commands/#{nick.downcase}", {command => 1})
  end
end
