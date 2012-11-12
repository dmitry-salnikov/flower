class Flower::Command
  def self.respond_to(*commands)
    commands.each do |command|
      if Flower::COMMANDS[command]
        warn "Command already defined: #{command}"
      else
        Flower::COMMANDS[command] = self if allowed_command?(command)
      end
    end
  end

  def self.allowed_command?(command)
    return true if Flower::Config.parental_control.nil?
    Flower::Config.parental_control.include?(command)
  end

  def self.listen_to(*regexps)
    regexps.each do |regexp|
      if Flower::LISTENERS[regexp]
        warn "Listener already defined: #{regexp}"
      else
        Flower::LISTENERS[regexp] = self
      end
    end
  end

  def self.delegate_command(command, message, sender, flower)
    return false if Flower::COMMANDS[command].nil?
    begin
      Flower::COMMANDS[command].respond(command, message, sender, flower)
    rescue => error
      post_error(error, command, message, sender, flower)
      puts error
      puts error.backtrace
    end
  end

  def self.register_stats(command, sender)
    Flower::Stats.store_leaderboard_stat(sender[:nick])
    Flower::Stats.store_command_stat(command, sender[:nick])
  end

  def self.trigger_listeners(message, sender, flower)
    return false if Flower::LISTENERS.empty?
    Flower::LISTENERS.map do |regexp, command|
      begin
        command.listen(message, sender, flower) if message.match(regexp)
      rescue => error
        post_error(error, "", message, sender, flower)
        puts error
        puts error.backtrace
      end
    end
  end

  private
  def self.post_error(error, command, message, sender, flower)
    flower.say(":( `#{command}` raised error: #{error}")
  end
end
