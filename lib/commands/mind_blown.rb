# encoding: UTF-8
class MindBlown < Flower::Command
  respond_to "mindblown"

  def self.description
    "Mind blown!"
  end

  def self.respond(message)
    message.say 'http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif'
  end
end
