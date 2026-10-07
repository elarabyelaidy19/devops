# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../app'

class GreetTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def teardown
    ENV.delete('FEATURE_GREET')
  end

  def test_greet_is_hidden_when_flag_is_off
    get '/greet', name: 'Sara'

    assert_equal 404, last_response.status
  end

  def test_greet_works_when_flag_is_on
    ENV['FEATURE_GREET'] = 'on'
    get '/greet', name: 'Sara'

    assert_equal 200, last_response.status
    assert_equal({ 'message' => 'Hello, Sara' }, JSON.parse(last_response.body))
  end

  def test_greet_defaults_to_world
    ENV['FEATURE_GREET'] = 'on'
    get '/greet'

    assert_equal 'Hello, world', JSON.parse(last_response.body)['message']
  end
end
