# frozen_string_literal: true

require 'faraday'
require_relative 'response'

module Github
  class Client
    attr_reader :endpoint, :token

    def initialize(endpoint, token)
      @endpoint = endpoint
      @token = token
    end

    def repositories(query:, per_page: 10, page: 1)
      result = connection.get(
        'search/repositories',
        { q: query, per_page: per_page, page: page },
      )

      Github::Response.new(result)
    end

    private

    def connection
      @connection ||= Faraday.new(
        url: endpoint,
        headers: headers,
      )
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/vnd.github.v3+json',
        'Authorization' => "token #{token}",
      }
    end
  end
end
