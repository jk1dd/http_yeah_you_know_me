require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'
# require './lib/refactored_server'

class ServerTest < Minitest::Test

  def test_responds_200
    skip
    response = Faraday.get 'http://127.0.0.1:9292/'
    assert_equal 200, response.status
  end

  def test_returns_correct_hello_count
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    expected = "<html><head></head><body><h1> Hello World! (1) </h1></body></html>"

    assert_equal expected, response.body

    response = Faraday.get 'http://127.0.0.1:9292/hello'
    expected = "<html><head></head><body><h1> Hello World! (2) </h1></body></html>"

    assert_equal expected, response.body
  end
end
