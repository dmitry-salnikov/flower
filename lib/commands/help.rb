# encoding: utf-8

class Help < Flower::Command
  respond_to "help", "hjälp", "?"

  def self.respond(command, message, sender, flower)
    if message == ""
      flower.say("Available commands:")
      flower.paste(help_text)
    else
      flower.paste(help_command(message) || "nothing found")
    end
  end

  def self.description
    "This message"
  end

  private
  def self.help_text
    command_hash = Flower::COMMANDS.inject({}) do |memo, (k, v)|
      memo[v] ? memo[v] << "/#{k}" : memo[v] = k.dup; memo
    end

    longest_command = command_hash.values.inject do |memo, c|
       memo.length > c.length ? memo : c
    end

    text_array = []
    command_hash.reject{ |_, c| c.nil? || c.empty? }.each do |klass, command|
      text_array << command.ljust(longest_command.length + 5)
    end
    text_array.sort
  end

  def self.help_command(command)
    Flower::COMMANDS[command].description if Flower::COMMANDS.has_key? command
    #    "#{"#{klass.description}" if klass.respond_to?(:description)}"
  end
end
