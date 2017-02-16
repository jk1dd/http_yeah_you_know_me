require 'faraday'
require 'minitest/autorun'
require 'minitest/pride'

class ServerTest < Minitest::Test
  i_suck_and_my_tests_are_order_dependent!

  def test_responds_200
    response = Faraday.get 'http://127.0.0.1:9292/'
    assert_equal 200, response.status
  end

  def test_can_get_diagnostics
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head>\n<body>   \n<pre>Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort:9292\nOrigin: 127.0.0.1\nAccept: */*</pre>\n</body>\n</html>"

    assert expected, response.body
  end

  def test_returns_hello_and_correct_hello_count
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert response.body.include?("Hello World! (1)")

    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert response.body.include?("Hello World! (2)")
  end

  def test_can_return_datetime
    response = Faraday.get 'http://127.0.0.1:9292/datetime'

    assert response.body.include?("2017")
    assert response.body.include?("Path: /datetime")
  end

  def test_can_get_word_search
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=the'

    assert response.body.include?("THE is a known word")
  end

  def test_unknown_page_returns_blank
    response = Faraday.get 'http://127.0.0.1:9292/afdjklwnendkk'
    expected = "<html><head></head><body></body></html>"
    assert_equal expected, response.body
  end

  def test_zzz_can_it_can_return_total_request_phrase
    response = Faraday.get 'http://127.0.0.1:9292/shutdown'

    assert response.body.include?("Total Requests:")
  end
end
