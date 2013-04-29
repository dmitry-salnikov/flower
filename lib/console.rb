class Flower::Console
  def self.post_message(message, tags = [], flow)
    message
  end

  def self.command message
    msg = Flower::Message.new({flow: '123'})
    msg.sender = {nick: 'console'}
    msg.message = message
    msg.rest = Flower::Console
    if msg.bot_message?
      Flower::COMMANDS[msg.command].respond(msg) if Flower::COMMANDS.has_key?(msg.command)
    end
  end

  def self.listen message
    msg = Flower::Message.new({flow: '123'})
    msg.message = message
    msg.rest = Flower::Console

    results = []
    Flower::LISTENERS.each do |regexp, command|
      results << command.listen(msg) if msg.message.match(regexp)
    end
    results.reject{|r| r.is_a? Hash }
  end
end
