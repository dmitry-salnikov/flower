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
    message.say DICES.sample
  end
end
