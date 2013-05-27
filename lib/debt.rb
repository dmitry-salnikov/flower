require 'redis'

class Debt
  class ParameterMissingError < StandardError; end

  attr_reader :to, :from, :amount

  def initialize opts = {}
    @from = opts.fetch(:from) { raise Debt::ParameterMissingError }
    @to = opts.fetch(:to) { raise Debt::ParameterMissingError }
    @amount = opts[:amount]
  end

  def create!
    value = previous_amount + amount
    save_to_database(value)
  end

  private

  def debt_key
    "#{from}-#{to}"
  end

  def save_to_database value
    redis.set debt_key, value
  end

  def previous_amount
    redis.get(debt_key).to_i
  end

  def redis
    @redis ||= Redis.new
  end
end
