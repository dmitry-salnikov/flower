require 'redis'

# encoding: utf-8
class TechSupport < Flower::Command
  respond_to 'tech', 'techsupport'

  def self.respond(message)
    redis.set(week, message.argument.capitalize) if message.argument
    message.say tech_of_the_week
  end

  def self.description
    "Who has techsupport this week?"
  end

  private

  def self.redis
    @@redis ||= Redis.new
  end

  def self.tech_of_the_week
    if dev = redis.get(week)
      "#{dev} & Li are TechSupport this week"
    else
      "Use `!tech NAME` to set who has TechSupport with Li"
    end
  end

  def self.week
    Time.now.strftime('%U').to_i + 1
  end
end

