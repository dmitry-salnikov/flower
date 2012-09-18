require_relative 'eliza/client'

class Eliza < Flower::Command
  respond_to "eliza"

  def self.description
    "Analyze this!"
  end

  def self.respond(command, message, sender, flower)
    flower.say eliza.processInput(message)
  end

  private

  def self.eliza
    @eliza ||= Client.new(File.dirname(__FILE__) + "/eliza/scripts/original.txt")
  end
end
