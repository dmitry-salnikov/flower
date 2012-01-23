class PokeUrl < Flower::Command
  respond_to "poke", "unpoke", "pokes"
  require 'typhoeus'

  def self.description
    "keep heroku apps alive"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "poke"
      flower.say(add_poke(message))
    when "unpoke"
      flower.say(remove_poke(message))
    when "pokes"
      url = list_pokes
      if url.empty?
        flower.say("Pokes no urls")
      else
        flower.say("Pokes following urls:")
        flower.paste(url.join("\n"))
      end
    end
  end

  private

  def self.add_poke(url)
    response = Typhoeus::Request.post(Flower::Config.poke_url + "&url=#{url}")
    response.code == 200 ? response.body : "failed..."
  end

  def self.remove_poke(url)
    response = Typhoeus::Request.delete(Flower::Config.poke_url + "&url=#{url}")
    response.code == 200 ? response.body : "failed..."
  end

  def self.list_pokes
    response = Typhoeus::Request.get(Flower::Config.poke_url)
    response.code == 200 ? JSON.parse(response.body) : ["hej", "ho"]
  end
end