class BangBang < Flower::Command
  listen_to /^!(.+)/i
  respond_to "!"

  def self.listen(message, sender, flower)
    @@previous = {message: message, sender: sender} unless message =~ /^!!/
  end

  def self.respond(command, message, sender, flower)
    flower.respond_to({content: @@previous[:message], internal: true, user: sender[:id]})
  end


  def self.description
    "repeat last used command"
  end
end
