require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'
# require './lib/refactored_server'

class ServerTest < Minitest::Test

  def test_responds_200
    response = Faraday.get 'http://127.0.0.1:9292/'
    assert_equal 200, response.status
  end

  def test_returns_correct_hello_count
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert response.body.include?("Hello World! (1)")
    # expected = "<html><head></head><body><h1> Hello World! (1) </h1></body></html>"
    #
    # assert_equal expected, response.body

    response = Faraday.get 'http://127.0.0.1:9292/hello'
    # expected = "<html><head></head><body><h1> Hello World! (2) </h1></body></html>"
    assert response.body.include?("Hello World! (2)")
    # assert_equal expected, response.body
  end

  def test_can_get_diagnostics
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head>
    <body>
        <pre>Verb: GET
Path: /
Protocol: HTTP/1.1
Host: 127.0.0.1
Port:9292
Origin: 127.0.0.1
Accept: */*</pre>
    </body>
</html>"

    assert expected, response.body
  end

  def 
end
