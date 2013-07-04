# encoding: UTF-8
require_relative 'sound_command'
class Friday < SoundCommand
  respond_to "friday"
  respond_to "thursday"

  def self.description
    "We, we, we so excited!"
  end

  def self.respond(message)
    if Time.now.wday == 5
      play_file("friday/friday.mp3")
    elsif Time.now.wday == 4
      play_file("friday/thursday.mp3")
    else
      message.say("Today is not a Rebecca Black day", :mention => message.user_id)
    end
  end
end