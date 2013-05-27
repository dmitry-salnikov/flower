require 'redis'

class Debt
  class ParameterMissingError < StandardError; end

  attr_reader :to, :from, :amount, :total

  def initialize opts = {}
    @from = opts.fetch(:from) { raise Debt::ParameterMissingError }
    @to = opts.fetch(:to) { raise Debt::ParameterMissingError }
    @amount = opts[:amount]
    @total = previous_amount + amount
  end

  def create!
    save_to_database
  end

  private

  def debt_key
    "#{from}-#{to}"
  end

  def save_to_database
    redis.set debt_key, total
  end

  def previous_amount
    redis.get(debt_key).to_i
  end

  def redis
    @redis ||= Redis.new
  end
end
