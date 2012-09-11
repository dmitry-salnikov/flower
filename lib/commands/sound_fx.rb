# encoding: UTF-8
require_relative 'sound_command'
class SoundFx < SoundCommand
  respond_to "easy", "rimshot", "sad", "yeah", "applause", "bomb", "suprise", "snore", "godwillsit", "sting", "pengar", "rik", "fel", "khan", "tarelugn", "tadetlugnt", "keke", "judas", "priest", "fascinating"

  def self.description
    "Awesome audio fx!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "easy"
      play_file "easy.mp3"
    when "rimshot"
      play_file "rimshot.mp3"
    when "sad"
      play_file "sadtrombone.mp3"
    when "yeah"
      play_file "yeah.mp3"
    when "applause"
      play_file "applause.mp3"
    when "bomb"
      play_file "bomb.mp3"
    when "suprise"
      play_file "suprise.m4r"
    when "snore"
      play_file "snore.wav"
    when "godwillsit"
      play_file "godwillsit.m4a"
    when "pengar"
      play_file "pengar.mp3"
    when "rik"
      play_file "rik.mp3"
    when "fel"
      play_file "fel.mp3"
    when "sting"
      play_file "sting.wav"
    when "khan"
      play_file "khan.wav"
    when "tarelugnt"
      play_file "tadetlugnt.wav"
    when "tadetlugnt"
      play_file "tadetlugnt.wav"
    when "keke"
      play_file %w(pengar fel rik).sample.tap { |keke| keke << ".mp3" }
    when /judas|priest/
      play_file "judas/judas#{rand(25)+1}.mp3"
    when "fascinating"
      play_file "fascinating.mp3"
    end
  end
end
