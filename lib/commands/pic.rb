class Pic < Flower::Command
  respond_to "pic", "picture", "image", "rpic"
  require 'open-uri'
  require 'json'
  require 'cgi'

  IMAGE_CACHE = {}

  def self.description
    "Post a picture from search string"
  end

  def self.respond(command, message, sender, flower)
    begin
      if command == "rpic"
        image = search_bing(message, true)
        flower.say(image)
      else
        image = IMAGE_CACHE.has_key?(message) ? IMAGE_CACHE[message] : search_bing(message)
        flower.say(image)
      end
    rescue NoMethodError
      flower.say("sorry, no matches")
    end
  end

  def self.search_bing(query, random = false)
    limit = random ? 50 : 1
    url = "http://api.search.live.net/json.aspx?AppId=#{Flower::Config.live_id}&Query=#{CGI.escape "\"#{query}\""}&Sources=Image&Version=2.0&Adult=Moderate&Image.Count=#{limit}"
    json = JSON.parse(open(url).read)
    if random
      image_url = json["SearchResponse"]["Image"]["Results"].shuffle[0]["MediaUrl"]
    else
      image_url = json["SearchResponse"]["Image"]["Results"][0]["MediaUrl"]
    end
    image_url.match(/(jpg|png|gif)$/) ? image_url : image_url + "#.jpg"
  end
end