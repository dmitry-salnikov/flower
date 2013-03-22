module Google
  class Search
    class Image < self
      TYPES = :face, :photo, :clipart, :lineart, :animated
    end
  end
end

class Gif < Flower::Command
  respond_to "gif"
  require 'open-uri'

  def self.description
    "Search for a gif or Post a random gif"
  end

  def self.respond(message)
    if query = message.argument
      message.say(gif_search(query))
    else
      message.say(random_gif)
    end
  end

  def self.random_gif
    url = "http://www.gif.tv/gifs/get.php"
    'http://www.gif.tv/gifs/' + open(url).read + '.gif'
  end

  def self.gif_search(query)
    results = Google::Search::Image.new(:query => query, :image_type => :animated).to_a
    url = results.sample.uri
    URI.encode url
  end
end