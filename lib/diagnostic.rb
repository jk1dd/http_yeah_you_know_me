module Diagnostic
  def self.diagnostics(request_lines)
    verb = request_lines[0].split[0]
    @path = request_lines[0].split[1].split("?")[0]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[-3].split[1]

    " <pre>Verb: #{verb}\nPath: #{@path}\nProtocol: #{protocol}\nHost: #{host}\nPort:#{port}\nOrigin: #{origin}\nAccept: #{accept}</pre>"
  end
end
