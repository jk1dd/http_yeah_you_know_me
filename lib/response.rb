class Response

  def initialize
    @hello_counter = 0
  end

  def hello
    @hello_counter += 1
    "<h1> Hello World! (#{@hello_counter}) </h1>"
  end

  def datetime
     " <h1>#{Time.now.strftime('%H:%M%p on %A, %B %w, %Y')}</h1> "
  end

  # def shutdown
  #   @server_exit = true
  #   " <h1>Total Requests: #{@request_total} </h1> "
  # end

end
