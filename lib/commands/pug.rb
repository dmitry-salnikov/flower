class Pub < Flower::Command
  respond_to "pug"
  require 'typhoeus'

  def self.description
    "Give me a pug plz"
  end

  def self.respond(command, message, sender, flower)
    flower.say(image)
  end

  private

  def self.image
    JSON.parse(Typhoeus::Request.get("http://pugme.herokuapp.com/random").body)["pug"]
  end
end