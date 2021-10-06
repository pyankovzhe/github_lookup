# frozen_string_literal: true

require 'json'

module Github
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def data
      JSON.parse(response.body).transform_keys(&:to_sym)
    end

    def success?
      response.success?
    end

    def error_message
      return if success?

      [response.status, data[:message]].compact.join(' ')
    end
  end
end
