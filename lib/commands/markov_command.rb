require_relative 'markov/markov'

class MarkovCommand < Flower::Command
  listen_to /^.*$/
  respond_to "markov"

  def self.description
    "Data from the Markov chain"
  end

  def self.listen(message)
    transport.open
    client.add message.message
    transport.close
  rescue
  end

  def self.respond(message)
    transport.open
    message.say(client.get, mention: message.user_id)
    transport.close
  rescue
  end

  private

  def self.transport
    @transport ||= Thrift::BufferedTransport.new(Thrift::Socket.new('127.0.0.1', 9090))
  end

  def self.protocol
    @protocol ||= Thrift::BinaryProtocol.new(transport)
  end

  def self.client
    @client ||= Markov::Client.new(protocol)
  end
end
