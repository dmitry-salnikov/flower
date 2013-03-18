# encoding: UTF-8
class Wat < Flower::Command
  respond_to "wat"

  WATS = %w[
    http://cdn.shopify.com/s/files/1/0070/7032/files/wat_grande.jpg
    http://anongallery.org/img/1/9/wat-gigantic-duck.jpg
    http://www.friendshipismagic.org/forum/attachment.php?attachmentid=9452&d=1341514337.jpg
    http://static.fjcdn.com/pictures/Wat_5e732b_4019847.jpg
    http://i3.kym-cdn.com/photos/images/newsfeed/000/173/576/Wat8.jpg
    http://i3.kym-cdn.com/photos/images/newsfeed/000/173/589/RsLid.jpg
    http://images.cryhavok.org/d/13825-2/Wat.jpg
    http://4.bp.blogspot.com/_y71reyDy9lg/TB82-82DzeI/AAAAAAAABLM/AE72Bvwh5tE/s1600/WAT.jpg
    http://cdn.shopify.com/s/files/1/0070/7032/files/darth_wat_grande.jpg
    http://i.imgur.com/aGZxe.jpg
    http://img1.joyreactor.com/pics/post/funny-pictures-auto-panda-muscles-389021.jpeg
    http://25.media.tumblr.com/tumblr_mbqhqcQOlN1rhdfk0o1_500.jpg
  ]

  def self.description
    "WAT!? – http://www.youtube.com/watch?v=kXEgk1Hdze0"
  end

  def self.respond(message)
    if (1..WATS.size).include?(message.argument.to_i)
      message.say WATS[message.argument.to_i - 1]
    else
      message.say WATS.sample
    end
  end
end