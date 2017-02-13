require 'pry'
require 'socket'

class MyServer
  attr_reader :tcp_server
  def initialize(port)
    @tcp_server = TCPServer.new(9292)
    # @client = @tcp_server.accept
    @response_counter = 0
    @hello_counter = 0
  end

  def connect
    loop do
      client = tcp_server.accept
      diagnostics = request_lines_collected(client)
    end
  end

  def request_lines_collected
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end
end
