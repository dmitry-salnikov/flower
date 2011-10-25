require 'spec_helper'

describe Flower::Session do
  before do
    @session = Flower::Session.new(Flower.new)
  end

  describe "#login" do
    before do
      @session.stub(:handshake).and_return(true)
    end
    it "should set cookie and call Session#handshake if login is successful" do
      stub_request(:post, "https://www.flowdock.com/session").to_return(:body => "abc", :status => 302,  :headers => { 'SET_COOKIE' => ["cookies!!!", "cookie!"] } )
      @session.should_receive(:handshake)
      lambda{
        EM.run {
          @session.login
          EM.stop
        }
      }.should change{@session.cookie}.from(nil).to(String)
    end

    it "should exit program if login failed" do
      stub_request(:post, "https://www.flowdock.com/session").to_return(:status => 200 )
      lambda{
        EM.run {
          @session.login
          EM.stop
        }
      }.should raise_error(RuntimeError, "Error on connect...") 
    end
  end

  describe "#handshake" do
    before do
      @session.stub(:join).and_return(true)
    end
    it "does a get request and saves the users and calls Session#join" do
      users = [1,2,3,4]
      stub_request(:get, /.*flowdock.com\/flows\/.*\.json/).to_return(:body => {:users => users}.to_json, :status => 200)
      @session.should_receive(:join)
      Flower.any_instance.should_receive(:get_users).with(users)
      EM.run {
        @session.handshake
        EM.stop
      }
    end
  end

  describe "#join" do
    it "should do a post request and call Session#subscribe" do
      stub_request(:post, "https://mynewsdesk.flowdock.com/messages")
      @session.should_receive(:subscribe)
      EM.run {
        @session.join
        EM.stop
      }
      WebMock.should have_requested(:post, "https://mynewsdesk.flowdock.com/messages").with(:body => {"channel"=>"/meta", "event"=>"join", "message"=>"{\"channel\":\"/flows/bot-debug-room\",\"client\":\"jnfEIHE23ff\"}"})
    end
  end

  describe "#subscribe" do
    it "subscribes to a room"
  end

  describe "#post" do
    it "should post the given params" do
      stub_request(:post, "https://mynewsdesk.flowdock.com/messages")
      EM.run {
        @session.post("hello world", nil)
        EM.stop
      }
      WebMock.should have_requested(:post, "https://mynewsdesk.flowdock.com/messages").with(:body => {"message"=>"\"hello world\"", "app"=>"chat", "event"=>"message", "tags"=>"", "channel"=>"/flows/bot-debug-room"})
    end
  end
end
