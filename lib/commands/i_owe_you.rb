# encoding: utf-8
require_relative '../iou'

class IOweYou < Flower::Command
  respond_to "iou"

  class << self
    def description
      "Your bank™, in your chat!"
    end

    def respond message
      return message.paste "Usage: !iou [name] ([amount])" unless message.argument

      sender = message.sender[:nick].downcase
      receiver = message.argument.split(" ").first.downcase
      amount = message.argument.split(" ")[1]

      debt = ::IOU::Debt.new(sender: sender, receiver: receiver, amount: amount.to_i)
      if receiver && amount
        if debt.create!
          message.paste "Debt to #{receiver.capitalize} registered for #{amount} SEK. Total debt: #{debt.previous_amount} SEK"
        end
      elsif receiver
        if debt.previous_amount > 0
          message.paste "You owe #{debt.previous_amount} SEK to #{receiver.capitalize}"
        elsif debt.previous_amount < 0
          message.paste "#{receiver.capitalize} owes you #{-debt.previous_amount} SEK"
        else
          message.paste "No debts between you and #{receiver.capitalize}!"
        end
      end
    end
  end
end
