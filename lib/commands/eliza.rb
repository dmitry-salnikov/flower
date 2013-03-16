require_relative 'eliza/client'

class Eliza < Flower::Command
  REGEXP = /^bot([\s,]|$)/i
  listen_to REGEXP

  def self.description
    "Analyze this!"
  end

  def self.listen(message)
    m = message.message.sub(REGEXP, "").strip
    message.say eliza.processInput(m)
  end

  private

  def self.eliza
    @eliza ||= Client.new(File.dirname(__FILE__) + "/eliza/scripts/original.txt")
  end
end
