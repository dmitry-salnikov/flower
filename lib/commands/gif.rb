class Gif < Flower::Command
  respond_to "gif"
  require 'open-uri'

  IMAGE_CACHE = {}

  def self.description
    "Post a random gif"
  end

  def self.respond(command, message, sender, flower)
    flower.say(image)
  end

  def self.image
    url = "http://www.gif.tv/gifs/get.php"
    'http://www.gif.tv/gifs/' + open(url).read + '.gif'
  end
end