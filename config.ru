# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require './app'

App.freeze unless ENV['APP_ENV'] == 'development'

run App
