class Die < Flower::Command
  respond_to "die", "kill", "going-down"

  def self.respond(command, message, sender, flower)
    flower.say "Nooooooo...!"
    exit
  end

  def self.description
    "Kill me ;("
  end
end
