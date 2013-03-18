class Pid < Flower::Command
  respond_to "pid"

  def self.respond(message)
    message.say "My pid is: #{message.flower.pid}"
  end

  def self.description
    "Get the bot process pid"
  end
end
