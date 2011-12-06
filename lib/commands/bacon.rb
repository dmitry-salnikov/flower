class Bacon < Flower::Command
  listen_to /bacon/i
  
  def self.description
    "bacon is the shit"
  end

  def self.listen(message, sender, flower)
    Pic.respond("rpic", "bacon", sender, flower)
  end
end