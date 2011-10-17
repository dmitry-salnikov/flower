require 'spec_helper'

describe Flower do
  before do
    @flower = Flower.new
  end

  describe "#new" do
    # %w(messages_url post_url flow_url).each do |attribute|
    #   it "should set the #{attribute} attributes" do
    #     @flower.send(attribute).should_not be_nil
    #     @flower.send(attribute).should be_a(String)
    #   end
    # end

    it "should set a session" do
      @flower.session.should be_a(Flower::Session)
    end

    it "should default users to empty hash" do
      @flower.users.should == {}
    end
  end

  describe "#say" do
    it "should post the message" do
      def @flower.post(*args)
        @posted = true if args == ["Hello World", nil]
      end
      @flower.say("Hello World")
      @flower.instance_variable_get("@posted").should be_true
    end

    it "should mention a user by passing a tag" do
      Flower::Session.any_instance.should_receive(:post).with("Hello World",[":highlight:1"])
      @flower.say("Hello World", :mention => 1)
    end
  end

  describe "#paste" do
    it "should post a message preceded with 4 spaces" do
      Flower::Session.any_instance.should_receive(:post).with("    Hello World", nil)
      @flower.paste("Hello World")
    end

    it "should join an array into a multi-line paste" do
      def @flower.post(*args)
        @posted = true if args.first == "    Hello\\n    World"
      end
      @flower.paste(%w(Hello World))
      @flower.instance_variable_get("@posted").should be_true
    end

    it "should mention a user by passing a tag" do
      Flower::Session.any_instance.should_receive(:post).with("    Hello World",[":highlight:2"])
      @flower.paste("Hello World", :mention => 2)
    end
  end
end
