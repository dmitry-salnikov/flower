#!/usr/bin/env ruby
# encoding: UTF-8

class Ipay < Flower::Command
  respond_to "ipay", "transaction"

  def self.description
    "Just a payment proof of concept"
  end

  def self.respond(message)
    if message.argument.blank?
      message.say Account.new.to_s
    else
      account = Account.new
      if command == 'ipay'
        begin
          to_user, amount = message.argument.split(' ', 2)
          amount = amount.to_i
          transaction = Transaction.new("#{to_user} #{-amount} #{nick} #{amount}")
          account.append(transaction)
        rescue
          message.say 'Usage: !ipay janne 100'
        end
      elsif command == 'transaction'
        begin
          transaction = Transaction.new(message.argument.split(' '))
          account.append(transaction)
        rescue
          message.say 'Usage: !transaction janne +100 markus -50 teo -50'
        end
        message.say account.to_s
      end
    end
  end
end

class Transaction
  def initialize(argv)
    raise "No arguments" if argv.empty?
    raise "Inalid arguments" if argv.length % 2 != 0
    @transaction = {}.tap do |transaction|
      i = 0
      while i < argv.length
        transaction[argv[i].downcase] = argv[i+1].to_i
        i += 2
      end
      raise "Invalid amount" if transaction.values.any?{|v| v == 0}
      raise "Unbalanced" if transaction.values.inject{|sum,x| sum + x } != 0
    end
  end

  def to_h
    @transaction
  end

  def to_s
    @transaction.map{|k,v| "#{k} #{v}"}.join(' ')
  end
end

class Account
  def initialize
    @account = Hash.new(0)
    if File.exists?("transactions.txt")
      lines = File.open("transactions.txt").each_line do |line|
        add Transaction.new(line.split(' '))
      end
    end
  end

  def add(transaction)
    transaction.to_h.each do |k,v|
      balance = @account[k]
      balance += v
      if balance == 0
        @account.delete(k)
      else
        @account[k] = balance
      end
    end
  end

  def append(transaction)
    File.open("transactions.txt", 'a') {|f| f.puts(transaction.to_s)}
    add(transaction)
  end

  def to_s
    @account.map{|k,v| "#{k} #{v}"}.join("\n")
  end
end
