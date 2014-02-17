module SayWhatAgain
  class HTTP
    def initialize(url)
      @url = url
    end
    attr_reader :url

    def get(options = {})
      interface.get url, options
    end

    def post(options = {})
      interface.post url, options
    end

    private

    def interface
      Typhoeus::Request
    end
  end
end
