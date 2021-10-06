# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:test)
ENV['APP_ENV'] = 'test'
ENV['APP_SESSION_SECRET'] = Base64.encode64('Test session secret' * 4)

require 'webmock/rspec'
require 'roda'
require_relative '../app'

SPEC_DIR = Pathname(__FILE__).dirname
Dir[SPEC_DIR.join('support/**/*.rb')].each { |f| require f }
Dir[SPEC_DIR.join('../lib/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include JsonHelpers
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
