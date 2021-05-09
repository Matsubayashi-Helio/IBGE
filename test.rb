require 'optparse'
require_relative 'lib/cli'
require 'byebug'



options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: example.rb [options]"

  parser.on("-uUF", "--uf UF", String, "Show name frequency for UF") do |s|
    options[:state] = s
    Cli.show_names_by_uf(options[:state])

  end

  parser.on("-cCITY", "--city CITY", String, "Show name frequency for CITY") do |c|
    options[:city] = c
  end

  parser.on("-fNAMES", "--frequency NAMES", Array, "Show frequency of NAMES across decades") do |n|
    options[:names] = n
  end

  parser.on("-h", "--help", "Prints this help") do
    puts parser
    exit
  end
end.parse!

puts options

