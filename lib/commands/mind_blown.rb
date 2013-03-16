# encoding: UTF-8
class MindBlown < Flower::Command
  respond_to "mindblown"

  MINDBLOWN = %w[
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://palmettopublicrecord.org/wp-content/uploads/2012/12/Kevin-Butler-Mind-Blown.gif
  ]

  def self.description
    "Mind blown!"
  end

  def self.respond(message)
    message.say MINDBLOWN.sample
  end
end