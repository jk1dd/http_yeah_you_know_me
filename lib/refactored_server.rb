require 'pry'
require 'socket'
require_relative 'response'
class Server
  attr_reader :tcp_server, :path, :input_word, :request_lines, :hello_counter


  def initialize(port)
    @tcp_server = TCPServer.new(9292)
    # @hello_counter = 0
    @request_total = 0
    @server_exit = false
    @dictionary = File.read("/usr/share/dict/words").split("\n")
    @path = ""
    @input_word = ''
    # client = @tcp_server.accept
    # @request_lines = []
  end
  # binding.pry
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
      # binding.pry
      client = start_server

      request_lines = collect_request_lines(client)
      puts "Got this request: "
      puts request_lines.inspect
      @request_total += 1

      # @path = request_lines[0].split[1].split("?")[0]
      @input_word = request_lines[0].split[1].split("=")[1]
      diagnostics(request_lines)
      response = path_decider(request_lines)

      # binding.pry
      puts "Sending response."


      # loop do
      # response = header_string #
      output = "<html><head></head><body>#{response}</body></html>"
      headers = [ "http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby:",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: #{output.length}\r\n\r\n"].join("\r\n")
        client.puts headers
        client.puts output
        # @response_counter += 1


        # puts ["Wrote this response:", headers, output].join("\n")
        puts "\nResponse complete, exiting."
      end
      client.close
  end

  def diagnostics(request_lines)
    verb = request_lines[0].split[0]
    @path = request_lines[0].split[1].split("?")[0]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[-3].split[1]

    " <pre>Verb: #{verb}\nPath: #{@path}\nProtocol: #{protocol}\nHost: #{host}\nPort:#{port}\nOrigin: #{origin}\nAccept: #{accept}</pre>"
  end

  def shutdown
    @server_exit = true
    " <h1>Total Requests: #{@request_total} </h1> "
  end

  def word_search(input_word)
    if @dictionary.include?(input_word)
      "#{input_word} is a known word"
    else
      "#{input_word} is not a known word"
    end
  end

  def path_decider(request_lines)
    response = Response.new
    case path
    when '/'
      diagnostics(request_lines)
    when '/hello'
      response.hello
    when '/datetime'
      response.datetime
    when '/shutdown'
      shutdown
    when '/word_search'
      word_search(input_word)
      # binding.pry
    end
  end

end


# if __FILE__ == $0
#   server = Server.new(9292)
# end
server = Server.new(9292)
server.communicate_with_server
# binding.pry
# ""
