class LocalServer < EventMachine::Connection
	attr_accessor :flower

	def set_flower(f)
		@flower = f
	end

	def receive_data(data)
		@flower.say(data.strip)
	end
end
