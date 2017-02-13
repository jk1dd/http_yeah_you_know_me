require 'socket'

tcp_server = TCPServer.new(9292)

hello_counter = 1
loop do
  client = tcp_server.accept
  request = client.gets
  STDERR.puts request
  output = "<html><head></head><body>Hello World! (#{hello_counter})</body></html>"
  headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  client.puts headers
  client.puts output
  client.close
  hello_counter += 1
end
