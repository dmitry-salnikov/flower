class BangBang < Flower::Command
  listen_to /^!(.+)/i
  respond_to "!"

  def self.listen(message)
    @@previous = message unless message.message =~ /^!!/
  end

  def self.respond(message)
    new_message = @@previous.dup
    new_message.sender = message.sender
    new_message.internal = true

    message.flower.respond_to(new_message)
  end


  def self.description
    "repeat last used command"
  end
end
