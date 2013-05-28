require 'iou/debt'

describe IOU::Debt do
  describe '#initialize' do
    context 'invalid parameters' do
      it 'raises an error if no `sender` paramter is found' do
        expect { described_class.new receiver: 'batman', amount: 1 }.to raise_error IOU::Debt::ParameterMissingError
      end

      it 'raises an error if no `receiver` parameter is found' do
        expect { described_class.new sender: 'alfred', amount: 1 }.to raise_error IOU::Debt::ParameterMissingError
      end
    end
  end

  describe '#create!' do

    let(:debt) { described_class.new sender: 'Batman', receiver: 'Alfred', amount: 10 }

    context 'no previous amount' do
      it "should create" do
        Redis.any_instance.should_receive(:set).with(debt.send(:key).identifier, -10).and_return "OK"
        debt.should_receive(:balance) { 0 }
        debt.create!
      end
    end

    context 'previous amount' do
      it "should create" do
        debt.should_receive(:balance) { -10 }
        Redis.any_instance.should_receive(:set).with(debt.send(:key).identifier, -20).and_return "OK"
        debt.create!
      end
    end
  end

  describe '#balance' do
    context 'positive amount' do
      let(:debt) { described_class.new sender: 'alfred', receiver: 'batman', amount: 10 }

      it 'fetches the key from the database and returns a positive amount' do
        debt.stub(:balance) { 0 }
        debt.send(:new_balance).should == 10
      end
    end

    context 'negative amount' do
      let(:debt) { described_class.new sender: 'batman', receiver: 'alfred', amount: 20 }

      it 'fetches the key from the database and returns a negative amount' do
        debt.stub(:balance) { 0 }
        debt.send(:new_balance).should == -20
      end
    end
  end
end
