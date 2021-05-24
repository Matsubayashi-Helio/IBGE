# frozen_string_literal: true

require_relative 'state'
require_relative 'city'
require 'terminal-table'
require_relative 'name'
require 'byebug'

require 'optparse'

class Cli
  def self.user_input_uf
    print 'Digite a UF que deseja:'
    $stdin.gets.chomp
  end

  def self.input_city_name
    print 'Digite o nome da cidade:'
    $stdin.gets.chomp
  end

  def self.input_names
    print 'Digite um ou mais nomes, separados por vírgula(,):'
    input = $stdin.gets.chomp
    Name.names_frequency(input)
  end

  def self.show_ufs
    rows = []
    State.all.each do |s|
      rows << [s.uf, s.name]
    end
    uf_table = Terminal::Table.new headings: %w[UF ESTADO], rows: rows
    puts uf_table
  end

  def self.show_names_by_uf(uf)
    state = State.find_by(uf: uf.upcase)
    return true unless state

    show_table(state)
    show_table(state, 'F')
    show_table(state, 'M')

    false
  end

  def self.show_names_by_city(city)
    city_obj = City.find_by(name: city)
    return true unless city_obj

    show_table(city_obj)
    show_table(city_obj, 'F')
    show_table(city_obj, 'M')

    false
  end

  def self.show_table(location, gender = {})
    names = Name.rank_by_location(location.location_id, gender)
    rows = []
    title = "NOMES MAIS COMUNS DE #{location.name.upcase}"

    unless gender.empty?
      title += gender == 'F' ? ' (FEMININO)' : ' (MASCULINO)'
    end

    names.each do |n|
      percentage = percentage_total(location.population2019, n[:frequencia])
      rows << [n[:ranking], n[:nome], n[:frequencia], percentage]
    end
    table_location = Terminal::Table.new title: title, headings: ['RANK', 'NOME', 'FREQUENCIA', '% RELATIVA'],
                                         rows: rows

    puts table_location
  end

  def self.show_names_frequency(names)
    rows = []
    heading = ['PERÍODO']
    decade = []
    names.each do |name|
      heading << name[:nome]
      name[:res].each do |h|
        decade << h[:periodo]
      end
    end

    decade.uniq!
    teste = decade.uniq.sort
    decade.sort.each do |d|
      row = []
      dec = teste.shift

      row << (dec == '1930[' ? '< 1930' : dec.gsub(/\[/, '')[0..3])

      names.each do |name|
        found_decade = name[:res].find { |i| i[:periodo] == d }
        row << (found_decade ? found_decade[:frequencia] : '*')
      end
      rows << row
    end

    table_frequency = Terminal::Table.new title: 'FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010', headings: heading,
                                          rows: rows
    (0..names.length).each { |c| table_frequency.align_column(c, :center) }
    puts table_frequency
  end

  def self.command_check(input)
    keyword = input.split
    if keyword.first == 'app'
      aux = keyword.drop(1)
      command = aux.join(' ')
      OptParser.parse %W[#{command}]
    else
      input
    end
  end

  def self.percentage_total(location_total, name_total)
    ((name_total.to_f / location_total) * 100).ceil(3)
  end

  def self.input_format(input)
    input.downcase!
    words = input.split
    final_word = words.map do |w|
      if w.size <= 2
        next w.capitalize if w == 'la'

        next w
      elsif (w.size == 3) && ((w == 'dos') || (w == 'das') || (w == 'del'))
        next w
      else
        w.capitalize
      end
    end
    final_word.join(' ')
  end
end
