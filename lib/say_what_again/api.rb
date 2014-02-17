require 'typhoeus'
require 'json'
require_relative 'http'
require_relative 'collection'

module SayWhatAgain
  class Api
    def initialize(url, params = {})
      @url = url
      @params = params
    end
    attr_reader :url, :params

    def quotes
      response = http.get(params: params).body
      JSON.parse(response)["quotes"].map {|quote| Collection.new quote }
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
