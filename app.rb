# frozen_string_literal: true

require_relative 'lib/github/client'

class App < Roda
  plugin :render, engine: 'slim'
  plugin :sessions, secret: ENV['APP_SESSION_SECRET']

  plugin :flash

  route do |r|
    r.root do
      view('home')
    end

    r.get 'repositories' do
      @query = r.params['q']
      if @query.nil? || @query.empty?
        flash['errors'] = 'Please provide search term'
        r.redirect '/'
      end

      result = github.repositories(query: @query)

      unless result.success?
        flash['errors'] = result.error_message
        r.redirect '/'
      end

      @repositories = result.data[:items]
      view('home')
    end
  end

  def github
    @github ||= Github::Client.new(ENV['API_ENDPOINT'], ENV['API_ACCESS_TOKEN'])
  end
end
