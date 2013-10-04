class Dice < Flower::Command
  respond_to "dice"

  DICES = %w(
    http://openclipart.org/people/rg1024/dado_1.svg
    http://openclipart.org/people/rg1024/dado_2.svg
    http://openclipart.org/people/rg1024/dado_3.svg
    http://openclipart.org/people/rg1024/dado_4.svg
    http://openclipart.org/people/rg1024/dado_5.svg
    http://openclipart.org/people/rg1024/dado_6.svg
  )

  def self.description
    "Let's play dice!"
  end

  def self.respond(message)
    message.say DICES.sample
  end
end
