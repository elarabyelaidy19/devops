# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../app'

class HealthTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_health_returns_ok_with_dev_version_by_default
    get '/health'

    assert_equal 200, last_response.status
    assert_equal({ 'status' => 'ok', 'version' => 'dev' }, JSON.parse(last_response.body))
  end

  def test_health_reports_app_version_from_env
    ENV['APP_VERSION'] = 'abc1234'
    get '/health'

    assert_equal 'abc1234', JSON.parse(last_response.body)['version']
  ensure
    ENV.delete('APP_VERSION')
  end
end
