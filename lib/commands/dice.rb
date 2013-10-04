class Dice < Flower::Command
  respond_to "dice"

  DICES = %w(
    http://www.random.org/dice/dice1.png
    http://www.random.org/dice/dice2.png
    http://www.random.org/dice/dice3.png
    http://www.random.org/dice/dice4.png
    http://www.random.org/dice/dice5.png
    http://www.random.org/dice/dice6.png
  )

  def self.description
    "Let's play dice!"
  end

  def self.respond(message)
    num = 2
    num = message.argument.to_i if message.argument =~ /^\d+/
    num = 2 if num > 6 || num <= 0
    message.say num.times.map{ DICES.sample }.join(' ')
  end
end
