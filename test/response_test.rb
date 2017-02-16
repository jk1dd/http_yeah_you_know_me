require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/response'

class ResponseTest < Minitest::Test

  def setup
    @response = Response.new
  end

  def test_returns_hello
    assert_equal "<h1> Hello World! (1) </h1>", @response.hello
  end

  def test_returns_datetime
    assert_equal " <h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1> ", @response.datetime
  end

end
