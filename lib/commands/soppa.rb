require 'open-uri'
class Soppa < Flower::Command
  listen_to 'soppa'

  class << self
    def description
      'Veckans soppor'
    end

    def listen(message, sender, flower)
      flower.paste(fetch_ringos, :mention => sender[:id])
    end

    private
    def html
      open('http://iloapp.olandskan.se/blog/dagens').read
    end

    def menu
      menu = Nokogiri::HTML.parse(html).css('div.post').first.css('p').map(&:text)

      # First element whines about some sandwich
      menu.shift

      menu.join("\n")
    end
  end
end
