# encoding: UTF-8
class Merge < Flower::Command
  respond_to "merge"

  IMAGES = %w[
    http://cdn.memegenerator.net/instances/500x/46317286.jpg
    http://i.imgur.com/JISZt5A.png
  ]

  def self.description
    "Merge my pull request!"
  end

  def self.respond(message)
    message.say IMAGES.sample
  end
end
