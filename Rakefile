# encoding: UTF-8

desc "Run tests"
task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
end

desc "Start the bot"
task :run do
  require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'flower'))
  @flower = Flower.new
  @flower.boot!
end

desc "Open a console"
task :console do
  require_relative 'lib/flower'
  require_relative 'lib/console'
  require 'irb'
  require 'irb/completion'

  def message message
    results = []
    results << Flower::Console.command(message)
    results << Flower::Console.listen(message)
    results.flatten!
    results.compact!
    results.pop
    results
  end

  ARGV.clear
  IRB.start
end

Signal.trap(0) do
  @flower.say("I'm leaving (and/or crashing)... Goodbye!")
end
