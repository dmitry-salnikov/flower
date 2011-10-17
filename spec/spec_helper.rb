require 'rspec'
require 'webmock/rspec'
require 'pry'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'flower'))

RSpec.configure do |config|
  config.before(:each) do
    WebMock.disable_net_connect!
  end
end
