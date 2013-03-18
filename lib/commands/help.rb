# encoding: utf-8

class Help < Flower::Command
  respond_to "help", "hjälp", "?"

  def self.respond(message)
    if message.argument
      message.paste(help_command(message.argument) || "nothing found")
    else
      message.say("Available commands:")
      message.paste(available_commands)
    end
  end

  def self.description
    "This message"
  end

  private
  def self.available_commands
    Flower::COMMANDS.keys.sort
  end

  def self.help_command(command)
    Flower::COMMANDS[command].description if Flower::COMMANDS.has_key? command
  end
end
