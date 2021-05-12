#!/usr/bin/env ruby

require_relative 'config/environment'
# require 'cli'

puts "BEM VINDO!!!"
puts
puts "Esta aplicação fornece dados sobre frequência de nomes da população brasileira."
puts
puts

while true
    puts
    puts
    puts 'Digite app --help para visualizar todos os comandos.'
    print 'Informe qual comando deseja: '
    input = gets.chomp

    test = Cli.command_check(input)
end