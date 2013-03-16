# encoding: UTF-8
class Graph < Flower::Command
  respond_to "graph"

  GRAPHS = %w[
    http://c0.mndcdn.com/assets/redesign/components/partners/graphics/graph.png
  ]

  def self.description
    "Useful graphs!"
  end

  def self.respond(message)
    message.say GRAPHS.sample
  end
end