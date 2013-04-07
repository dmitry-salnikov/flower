# encoding: UTF-8
class Snowcat < Flower::Command
  respond_to "snowcat"

  def self.description
    "Cat in the snow, slowmo. Awesome!"
  end

  def self.respond(message)
    message.say "http://i.imgur.com/0RSkLtl.gif"
  end
end
