class Response

  attr_reader :hello_counter

  def initialize
    @hello_counter = 0
  end

  def hello
    @hello_counter += 1
    "<h1> Hello World! (#{hello_counter}) </h1>"
  end

  def datetime
     " <h1>#{Time.now.strftime('%H:%M%p on %A, %B %e, %Y')}</h1> "
  end


end
