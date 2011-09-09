class Uptime < Flower::Command
  respond_to "uptime"

  $booted = Time.now

  def self.respond(command, message, sender, flower)
    flower.say("I have been online for #{uptime}")
  end

  def self.description
    "Bot uptime"
  end

  private
  def self.uptime
    seconds = (Time.now - $booted).round
    hrs = (seconds / 3600)
    min = (seconds / 60) % 60
    sec = seconds % 60
    "#{hrs} hours, #{min} min, #{sec} sec"
  end
end