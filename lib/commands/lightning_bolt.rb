# encoding: UTF-8
require_relative 'sound_command'
class LightningBolt < SoundCommand
  respond_to "*", "**", "***", "****", "death"

  def self.description
    "Lightning bolt, lightning bolt, lightning bolt, DEATH!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "death"
      play_file "lightning_bolt/death.wav"
    when /\**/
      count = command.scan(/\*/).size.times do |i|
        if i <= 2
          play_file "lightning_bolt/lightning_bolt.wav", false
        else
          play_file "lightning_bolt/death.wav", false
        end
      end
    end
  end
end