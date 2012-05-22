require 'open-uri'
class Soppa < Flower::Command
  respond_to 'soppa'

  class << self
    def description
      'Dagens soppa'
    end

    def listen(message, sender, flower)
      flower.paste(menu, :mention => sender[:id])
    end

    private
    def html
      open('http://iloapp.olandskan.se/blog/dagens').read
    end

    def menu
      menu = Nokogiri::HTML.parse(html).css('div.post').first.css('p').map(&:text)
      menu[Time.now.strftime('%u').to_i]
    end
  end
end
