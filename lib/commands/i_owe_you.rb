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
      begin
        receiver = message.argument.split(" ").first.downcase
        amount = message.argument.split(" ")[1]
      rescue NoMethodError
        return message.paste "Usage: !iou [name] ([amount])"
      end
      debt = ::IOU::Debt.new(sender: sender, receiver: receiver, amount: amount.to_i)

      if receiver && amount
        if debt.create!
          message.paste "Debt to #{receiver.capitalize} registered for #{amount} SEK. Total debt: #{debt.previous_value} SEK"
        else
          "You fail, sir!"
        end
      elsif receiver
        if debt.previous_value > 0
          message.paste "You owe #{debt.previous_value} SEK to #{receiver.capitalize}"
        elsif debt.previous_value < 0
          message.paste "#{receiver.capitalize} owes you #{debt.previous_value} SEK"
        else
          message.paste "No debts between you and #{receiver.capitalize}!"
        end
      end
    end
  end
end
