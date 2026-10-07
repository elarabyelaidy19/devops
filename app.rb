# frozen_string_literal: true

require 'sinatra/base'
require 'json'

class App < Sinatra::Base
  helpers do
    def feature?(name)
      ENV["FEATURE_#{name.to_s.upcase}"] == 'on'
    end
  end

  get '/health' do
    content_type :json
    { status: 'ok', version: ENV.fetch('APP_VERSION', 'dev') }.to_json
  end

  get '/greet' do
    halt 404 unless feature?(:greet)

    content_type :json
    { message: "Hello, #{params.fetch('name', 'world')}" }.to_json
  end
end
