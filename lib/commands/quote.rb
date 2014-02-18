require_relative '../say_what_again/api'

class Quote < Flower::Command
  respond_to "quote", "saywhat"

  def self.description
    <<-DOC
    Posts a quote to our beloved quote bank
      Usage: !quote I destroyed a site - Jonny, Jonny's biggest mistake"
      Usage: !quote, # to receive a random quote"
    DOC
  end

  def self.respond(message)
    if message.argument
      body, rest      = message.argument.split(?-).map &:strip
      quotee, context = message.argument.split(?,).map &:strip
      response        = api(
        body: body, quotee: quotee, context: context
      ).create
    else
      message.paste api.quotes.sample.to_s
    end
  end

  private

  def self.api(params = {})
    api_key = Flower::Config.say_what_again_api_key
    url     = Flower::Config.say_what_again_quotes_url

    ::SayWhatAgain::Api.new url, api_key: api_key, quote: params
  end
end
