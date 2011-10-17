class Flower::Command
  def self.respond_to(*commands)
    commands.each do |command|
      if Flower::COMMANDS[command]
        warn "Command already defined: #{command}"
      else
        Flower::COMMANDS[command] = self
      end
    end
  end

  def self.delegate_command(command, message, sender, flower)
    return false if Flower::COMMANDS[command].nil?
    Thread.new do
      Flower::COMMANDS[command].respond(command, message, sender, flower)
    end
  rescue => error
    post_error(error, command, message, sender, flower)
    puts error
    puts error.backtrace
  end

  private
  def self.post_error(error, command, message, sender, flower)
    flower.say(":( `#{command}` raised error: #{error}")
  end
end
