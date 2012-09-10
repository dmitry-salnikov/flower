# encoding: utf-8
require 'open-uri'
class SL < Flower::Command
  respond_to 'sl'

  class << self
    def description
      'SL from Stockholm Södra'
    end

    def respond(command, message, sender, flower)
      flower.paste(soder, :mention => sender[:id])
    end

    private
    def html
      open('http://realtid.sl.se/?id=177&epslanguage=sv&WbSgnMdl=1365-U8O2ZHJhIHN0YXRpb24gKHDDpSBSb3Nlbmx1bmRzZykgKFN0b2NraG9sbSk%3d-_--_-_-_').read
    end

    def soder
      trs = Nokogiri::HTML.parse(html).css('div.trafficList tr')

      trs.map do |tr|
        tr.css("td").map do |td|
          td.text.gsub(/\t|\n|\r/,"")
        end.join(" ")
      end
    end
  end
end