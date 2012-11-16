# encoding: UTF-8
require_relative 'sound_command'
class Drama < SoundCommand
  respond_to "drama", "dundundun", "killbill", "chipmunk"
  listen_to /(siten|sajten).*nere/i

  def self.description
    "Dun dun DUN!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "drama"
      percent_of_the_time(98) ? dundundun(flower) : killbill
    when "dundundun"
      dundundun(flower)
    when "killbill"
      killbill
    when "chipmunk"
      dundundun(flower, chipmunk: true)
    end
  end

  def self.listen(message, sender, flower)
    killbill
  end

  private

  def self.dundundun(flower, opts = {})
    chipmunk = opts[:chipmunk] ||= percent_of_the_time(5)

    flower.say dramatic_chipmunk if chipmunk
    play_file "drama/dundundun.mp3"
  end

  def self.killbill
    play_file "drama/killbill.mp3"
  end

  def self.dramatic_chipmunk
    if percent_of_the_time(95)
      "http://media.tumblr.com/tumblr_mcfb858Vr91rwolbx.gif" # The chipmunk
    else
      "http://media.tumblr.com/tumblr_mcfbh0uNYn1rwolbx.gif" # Some dude
    end
  end

  def self.percent_of_the_time(n)
    rand(100) < n
  end
end