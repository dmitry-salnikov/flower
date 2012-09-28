require 'typhoeus'
class Loop < Flower::Command
  respond_to "loop"
  URL = "https://api.loopc.am/v1/loops/search"

  def self.description
    "Search for a loop"
  end

  def self.respond(command, message, sender, flower)
    flower.say image(message)
  end

  def self.image(query)
    json = JSON.parse(Typhoeus::Request.get(URL, {params: {q: query}}).body)
    json.sample["file_url"]
  end
end