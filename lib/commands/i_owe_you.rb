# encoding: utf-8
require_relative '../iou/debt'

class IOweYou < Flower::Command
  respond_to "iou"

  class << self
    def description
      "Your bank™, in your chat!"
    end

    def respond message
      sender = message.sender[:nick].downcase
      receiver = message.argument.split(" ").first.downcase
      amount = message.argument.split(" ")[1]
      debt = ::IOU::Debt.new(sender: sender, receiver: receiver, amount: amount.to_i)

      if receiver && amount
        if debt.create!
          message.paste "Debt to #{receiver.capitalize} registered for #{amount} SEK, total debt: #{debt.previous_value}"
        else
          "You fail, sir!"
        end
      elsif receiver
        message.paste "You owe #{debt.previous_value} SEK to #{receiver.capitalize}"
      end
    end
  end
end
