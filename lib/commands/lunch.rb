class Lunch < Flower::Command
  respond_to "ringos"
  require 'nokogiri'
  require 'open-uri'

  def self.description
    "Lunch menues, try 'ringos'"
  end

  def self.respond(message)
    flower.paste(fetch_ringos, :mention => sender[:id])
  end

  private

  def self.fetch_ringos
    doc = Nokogiri.HTML(open("http://www.kvartersmenyn.se/start/city/1/23").read)
    doc.at_css("span a[href='http://ringos.kvartersmenyn.se/']").ancestors("table").at_css("td:nth-child(2)").inner_html.gsub(/<div.*<\/div>/,"").strip
  end
end
