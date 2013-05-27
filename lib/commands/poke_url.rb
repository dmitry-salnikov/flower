class PokeUrl < Flower::Command
  respond_to "poke", "unpoke", "pokes"
  require 'typhoeus'

  def self.description
    "keep heroku apps alive"
  end

  def self.respond(msg)
    case msg.command
    when "poke"
      msg.say(add_poke(msg.argument).values)
    when "unpoke"
      msg.say(remove_poke(msg.argument).values)
    when "pokes"
      url = list_pokes
      if url.empty?
        msg.say("Pokes no urls")
      else
        msg.paste(["Poking:"] + url)
      end
    end
  end

  private

  def self.add_poke(url)
    response = Typhoeus::Request.post(Flower::Config.poke_url, params: {url: url})
    response.code == 200 ? JSON.parse(response.body) : "failed..."
  end

  def self.remove_poke(url)
    puts url.inspect
    response = Typhoeus::Request.delete(Flower::Config.poke_url, params: {url: url})
    response.code == 200 ? JSON.parse(response.body) : "failed..."
  end

  def self.list_pokes
    response = Typhoeus::Request.get(Flower::Config.poke_url)
    if response.code == 200
      JSON.parse(response.body).map do |poke|
        poke['url']
      end
    else
      "something went wrong"
    end
  end
end