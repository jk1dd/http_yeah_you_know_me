class ServerStarter
  def initialize(port)
    @tcp_server = TCPServer.new(port)
  end
end

starter = ServerStarter.new(9292)
