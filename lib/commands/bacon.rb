class Bacon < Flower::Command
  listen_to /bacon/i

  def self.description
    "bacon is the shit"
  end

  def self.listen(message)
    new_message = message
    new_message.message = "!rpic bacon"
    Pic.respond(new_message)
  end
end