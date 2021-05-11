require 'optparse'

OPTIONS = {}

OptionParser.new do |opts|
  opts.on('-t [INPUT]', '--type [INPUT]', 'Specify the type of email to be generated'){ |o| OPTIONS[:type] = o }
end.parse!

def say_hello
  puts "Hello #{OPTIONS[:type]}"
  puts
  puts OPTIONS[:type]
end  

case 
  when OPTIONS[:type]
    say_hello
  else
    puts "Hello World"
    puts OPTIONS[:type] unless nil; puts "No value given"
end