# encoding: UTF-8
class MindBlown < Flower::Command
  respond_to "mindblown"

  MINDBLOWN = %w[
    http://cdn.ebaumsworld.com/mediaFiles/picture/861722/82704856.gif
    http://palmettopublicrecord.org/wp-content/uploads/2012/12/Kevin-Butler-Mind-Blown.gif
    http://i930.photobucket.com/albums/ad145/howimetyourmothergifs/mindblown.gif
    http://media.tumblr.com/68f8c069dcc9a4ca9ecd6df476fd81b7/tumblr_inline_mgny3mRq2B1r29lcx.gif
  ]

  def self.description
    "Mind blown!"
  end

  def self.respond(command, message, sender, flower)
    flower.say MINDBLOWN.sample
  end
end