require 'typhoeus'
class Loop < Flower::Command
  respond_to "loop"
  URL = "https://api.loopc.am/v1/loops/search"

  def self.description
    "Search for a loop"
  end

  def self.respond(message)
    message.say image(message.argument)
  end

  def self.image(query)
    json = JSON.parse(Typhoeus::Request.get(URL, {params: {q: query}}).body)
    json.sample["file_url"]
  end
end