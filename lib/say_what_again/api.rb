require 'typhoeus'
require 'json'
require 'ostruct'
require 'say_what_again/http'

module SayWhatAgain
  class Api
    def initialize(url, params = {})
      @url = url
      @params = params
    end
    attr_reader :url, :params

    def quotes
      response = JSON.parse http.get.body
      response["quotes"].map {|quote| OpenStruct.new quote }
    end

    def create
      http.post params: params
    end

    private

    def http
      @http ||= HTTP.new url
    end
  end
end
