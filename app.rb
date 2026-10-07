# frozen_string_literal: true

require 'sinatra/base'
require 'json'

class App < Sinatra::Base
  get '/health' do
    content_type :json
    { status: 'ok', version: ENV.fetch('APP_VERSION', 'dev') }.to_json
  end
end
