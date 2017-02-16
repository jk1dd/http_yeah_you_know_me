require 'pry'
require 'socket'
require './lib/response'

class ServerMethods
  attr_reader :tcp_server, :path, :input_word, :request_lines, :response


  def initialize(port)
    @tcp_server = TCPServer.new(port)
    @request_total = 0
    @server_exit = false
    @dictionary = File.read("/usr/share/dict/words").split("\n")
    @path = ""
    @input_word = ''
    @response = Response.new
  end

  def start_server
    @tcp_server.accept
  end

  def collect_request_lines(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def communicate_with_server
    until @server_exit
      puts "Ready for request"
      client = start_server
      request_lines = collect_request_lines(client)
      puts "Got this request: "
      puts request_lines.inspect

      @request_total += 1
      diagnostics(request_lines)
      word_parser(request_lines)
      response = path_decider(request_lines)

      puts "Sending response."
      send_response(response, client)
    end
    client.close
  end

  def word_parser(request_lines)
    if path == '/word_search'
      @input_word = request_lines[0].split[1].split("=")[1]
    end
  end

  def send_response(response, client)
    output = "<html><head></head><body>#{response}</body></html>"
    headers = [ "http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby:",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      puts "\nResponse complete, exiting."
  end

  def diagnostics(request_lines)
    verb = request_lines[0].split[0]
    @path = request_lines[0].split[1].split("?")[0]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[-3].split[1]

    " <pre>Verb: #{verb}\nPath: #{@path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{origin}\nAccept: #{accept}</pre>"
  end

  def shutdown
    @server_exit = true
    " <h1>Total Requests: #{@request_total} </h1> "
  end

  def word_search(input_word)
    if @dictionary.include?(input_word)
      "<h1>#{input_word.upcase} is a known word</h1> "
    else
      "#{input_word.upcase} is not a known word"
    end
  end

  def path_decider(request_lines)
    case path
    when '/'
      diagnostics(request_lines)
    when '/hello'
      response.hello + diagnostics(request_lines)
    when '/datetime'
      response.datetime + diagnostics(request_lines)
    when '/shutdown'
      shutdown + diagnostics(request_lines)
    when '/word_search'
      word_search(input_word) + diagnostics(request_lines)
    end
  end

end
