require 'pry'
require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept

puts "Ready for request"
counter = 1
while client = tcp_server.accept
  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request: "
  puts request_lines.inspect

  verb = request_lines[0].split[0]
  path = request_lines[0].split[1]
  protocol = request_lines[0].split[2]
  host = request_lines[1].split(":")[1].lstrip
  port = request_lines[1].split(":")[2]
  origin = host
  accept = request_lines[-3].split[1]

  header_string =
  "<pre>Verb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort:#{port}\nOrigin: #{origin}\nAccept: #{accept}</pre>"
  # binding.pry
  puts "Sending response."


  # loop do
  response = header_string # "<pre>" + "Hello World! (#{counter})" + "</pre>"
  output = "<html><head></head><body>#{response}</body></html>"
  headers = [ "http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby:",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output
  counter += 1


  puts ["Wrote this response:", headers, output].join("\n")
  puts "\nResponse complete, exiting."
end
client.close
