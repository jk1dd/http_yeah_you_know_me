require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/refactored_server'

class ServerTest < Minitest::Test

  def test_responds_200
    response = Faraday.get 'http://127.0.0.1:9292/'
    assert_equal 200, response.status
  end
end
