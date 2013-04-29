require 'yaml'

class Flower::Config
  CONFIG = YAML.load File.read(ENV.fetch("CONFIG") {"config.yml"})

  def self.method_missing(sym, *args, &block)
    CONFIG[sym.to_s]
  end
end
