require 'pry'
require 'socket'
tcp_server = TCPServer.new(9292)
# client = tcp_server.accept
@hello_counter = 0
@request_total = 0
@server_exit = false


def diagnostics(request_lines, path)
  verb = request_lines[0].split[0]
  protocol = request_lines[0].split[2]
  host = request_lines[1].split(":")[1].lstrip
  port = request_lines[1].split(":")[2]
  origin = host
  accept = request_lines[-3].split[1]

  header_string =
  "<pre>Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort:#{port}\nOrigin: #{origin}\nAccept: #{accept}</pre>"
end

def hello
  "<h1>Hello World! (#{@hello_counter})</h1>"
  @hello_counter += 1
end

def datetime
   "<h1>{Time.now.strftime('%m %M %p on %A %B %w %Y')}</h1>"
end

def shutdown
  @server_exit = true
  "<h1>Total Requests: #{@request_total}"
end

puts "Ready for request"
until @server_exit
  client = tcp_server.accept
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request: "
  puts request_lines.inspect

  path = request_lines[0].split[1]
  @request_total += 1

  if path == '/'
    response = diagnostics(request_lines, path)
  elsif path == '/hello'
    response = hello
  elsif path == '/datetime'
    response == datetime
  elsif path == '/shutdown'
    response == shutdown
  end



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


    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete, exiting."
  end
client.close
