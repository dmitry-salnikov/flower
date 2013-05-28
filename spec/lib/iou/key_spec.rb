require 'iou/key'

describe IOU::Key do
  let(:key) { IOU::Key.new sender: "Batman", receiver: "Alfred" }

  describe "#initialize" do
    context 'downcases the names' do
      let(:key) { IOU::Key.new sender: "BatMAN", receiver: "alFREd" }
      it { key.sender.should == 'batman' }
      it { key.receiver.should == 'alfred' }
    end
  end

  describe '#identifier' do
    it 'constructs a redis key in alphabetical order' do
      key.identifier.should == 'alfred-batman'
    end
  end

  describe '#sender?' do
    context 'MiXeD cASE parameter' do
      context 'checks if a user is the sender' do
        it { key.sender?('BatMAn').should be_false }
        it { key.sender?('ALFred').should be_true }
      end
    end
  end
end
