require "async"
require "open-uri"

start = Time.now

Async do |task|
  task.async do
    pp "1"
    URI.open("https://httpbin.org/delay/1.6")
  end

  task.async do
    pp "2"
    URI.open("https://httpbin.org/delay/1.6")
  end
end

puts "Duration: #{Time.now - start}"


