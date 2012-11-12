# encoding: UTF-8
require_relative 'sound_command'
class Friday < SoundCommand
  respond_to "friday"

  def self.description
    "We, we, we so excited!"
  end

  def self.respond(command, message, sender, flower)
    if Time.now.wday == 5
      play_file("friday/friday.mp3")
    else
      flower.say("Today is not a Rebecca Black day", :mention => sender[:id])
    end
  end
end