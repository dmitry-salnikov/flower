# encoding: UTF-8
class Snowmonkey < Flower::Command
  respond_to "snowmonkey"

  def self.description
    "Monkey in winter clothing in the snow"
  end

  def self.respond(message)
    message.say "http://d24w6bsrhbeh9d.cloudfront.net/photo/ay51RmX_460sa.gif"
  end
end
