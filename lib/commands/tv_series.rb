# encoding: UTF-8
require_relative 'sound_command'
class TvSeries < SoundCommand
  respond_to "airwolf", "ateam"

  def self.description
    "Theme songs!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "airwolf"
      play_file "tv_series/airwolf.m4a"
    when "ateam"
      play_file "tv_series/a_team.m4a"
    end
  end
end