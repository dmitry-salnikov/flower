# encoding: UTF-8
class Merge < Flower::Command
  respond_to "merge"

  def self.description
    "Merge my pull request!"
  end

  def self.respond(message)
    message.say "http://cdn.memegenerator.net/instances/500x/46317286.jpg"
  end
end
