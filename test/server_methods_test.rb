require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/server_methods'

class ServerMethodsTest < Minitest::Test

  def setup
    @request_lines = ["GET /word_search?word=the HTTP/1.1",
 "Host: 127.0.0.1:9292",
 "Connection: keep-alive",
 "Cache-Control: no-cache",
 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
 "Postman-Token: 67c3c2ef-d152-fb1d-ab70-4075458d238e",
 "Accept: */*",
 "Accept-Encoding: gzip, deflate, sdch, br",
 "Accept-Language: en-US,en;q=0.8"]
  end


  def test_it_can_return_diagnostics
    server = ServerMethods.new(9291)
    
    assert_equal " <pre>Verb: GET\nPath: /word_search\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*</pre>", server.diagnostics(@request_lines)
  end

  def test_diagnostics_sets_the_path
    server = ServerMethods.new(9290)

    assert_equal "", server.path

    server.diagnostics(@request_lines)

    assert_equal "/word_search", server.path
  end

  def test_diagnostics_returns_formatted_request_lines
    server = ServerMethods.new(9289)

    assert_equal " <pre>Verb: GET\nPath: /word_search\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*</pre>", server.diagnostics(@request_lines)
  end

  def test_it_can_parse_word_from_request_lines
    server = ServerMethods.new(9292)
    server.diagnostics(@request_lines)
    # binding.pry
    assert_equal "the", server.word_parser(@request_lines)
  end

  def test_path_decider_can_direct_traffic
    server = ServerMethods.new(9293)
    server.diagnostics(@request_lines)
    server.word_parser(@request_lines)

    assert_equal "<h1>THE is a known word</h1>  <pre>Verb: GET\nPath: /word_search\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*</pre>", server.path_decider(@request_lines)
  end

end
