class Flower::Console
  def self.say(message, mention = nil)
    return message
  end

  def self.paste(message)
    return message.join("\n")
  end

  def self.command message
    if match = Flower.bot_message(message)
      match = match[1].split(" ")
      command = match.shift
      Flower::COMMANDS[command].respond(match.shift, match.join(" "), {id: 9}, Flower::Console) if Flower::COMMANDS.has_key?(command)
    end
  end

  def self.listen message
    results = []
    Flower::LISTENERS.each do |regexp, command|
      results << command.listen(message, {id: 0}, Flower::Console) if message.match(regexp)
    end
    results.reject{|r| r.is_a? Hash }
  end
end
