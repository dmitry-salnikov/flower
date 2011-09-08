task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
end

task :run do
  require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'flower'))
  @flower = Flower.new
  @flower.boot!
end

Signal.trap(0) do
  @flower.say("I'm leaving (and/or crashing)... Goodbye!")
end
