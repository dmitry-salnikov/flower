class Leaderboard < Flower::Command
  listen_to //i
  respond_to "leaderboard"

  STATS = {}

  def self.respond(command, message, sender, flower)
    stats_string = STATS.sort_by{ |key, value| value }.reverse.map do |nick, stats|
      puts "#{nick}: #{stats}"
    end
    flower.paste(stats_string)
  end

  def self.listen(message, sender, flower)
    register_message(sender[:nick])
  end

  private

  def self.register_message(nick)
    STATS[nick] ||= 0
    STATS[nick] += 1
  end
end
