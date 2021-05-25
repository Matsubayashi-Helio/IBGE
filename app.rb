#!/usr/bin/env ruby
# frozen_string_literal: true

require 'byebug'

require_relative 'config/environment'

puts 'BEM VINDO!!!'
puts
puts 'Esta aplicação fornece dados sobre frequência de nomes da população brasileira.'
puts
puts

loop do
  puts
  puts
  puts 'Digite app --help para visualizar todos os comandos.'
  print 'Informe qual comando deseja: '
  input = gets.chomp

  Cli.command_check(input)
end
