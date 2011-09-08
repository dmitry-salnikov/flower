class Pid < Flower::Command
  respond_to "pid"
  
  def self.respond(command, message, sender, flower)
    flower.say "My pid is: #{flower.pid}"
  end

  def self.description
    "Get the bot process pid"
  end
end
