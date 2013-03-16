require 'google-search'
class Pic < Flower::Command
  respond_to "pic", "picture", "image", "rpic"

  IMAGE_CACHE = {}

  def self.description
    "Post a picture from search string"
  end

  def self.respond(message)
    begin
      if message.command == "rpic"
        image = search_google(message.argument, true)
      else
        image = IMAGE_CACHE.has_key?(message.argument) ? IMAGE_CACHE[message.argument] : search_google(message.argument)
      end
      message.say(image)
    rescue NoMethodError
      flower.say("sorry, no matches")
    end
  end

  def self.search_google(query, random = false)
    results = Google::Search::Image.new(:query => query).to_a
    if random
      url = results.sample.uri
    else
      url = results[0].uri
    end
    URI.encode url
  end
end