require_relative 'state'
require_relative 'city'
require 'terminal-table'
require_relative 'name'
require 'byebug'

require 'optparse'

class Cli

    def self.user_input_uf
        print 'Digite a UF que deseja:'
        input = $stdin.gets.chomp
    
        return input
    end

    def self.get_city_name
        print 'Digite o nome da cidade:'
        input = $stdin.gets.chomp
        return input
    end
    
    def self.get_names
        print 'Digite um ou mais nomes, separados por vírgula(,):'
        input = $stdin.gets.chomp
        result = Name.names_frequency(input)
        return result
    end

    def self.show_ufs
        rows = []
        State.all.each do |s|
            rows << [s.uf, s.name]
        end
        uf_table = Terminal::Table.new :headings => ['UF', 'ESTADO'], :rows => rows
        puts uf_table
    end
    
    def self.show_names_by_uf(uf)
        state = State.find_by(uf: uf.upcase)
        return true unless state
        show_table(state)
        show_table(state, 'F')
        show_table(state, 'M')
        
        return false
    end
    
    def self.show_names_by_city(city)
        city_obj = City.find_by(name: city)
        return true unless city_obj
        show_table(city_obj)
        show_table(city_obj, 'F')
        show_table(city_obj, 'M')
        
        return false
    end
     
    def self.show_table(location, gender = {})
        names = Name.rank_by_location(location.location_id, gender)
        rows = []
        title = "NOMES MAIS COMUNS DE #{location.name.upcase}"
        
        unless gender.empty?
            if gender == 'F' then title += " (FEMININO)" else title += " (MASCULINO)" end 
        end
            
        names.each do |n|
            percentage = percentage_total(location.population_2019, n[:frequencia])
            rows << [n[:ranking], n[:nome], n[:frequencia], percentage]
        end
        table_location = Terminal::Table.new title: title, :headings => ['RANK', 'NOME', 'FREQUENCIA', '% RELATIVA'], :rows => rows
        
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
          
          if dec == '1930[' then row << '< 1930' else row << dec.gsub(/\[/, '')[0..3] end

          names.each do |name|
            found_decade = name[:res].find { |i| i[:periodo] == d }
            if found_decade then row << found_decade[:frequencia] else row << '*' end
          end
          rows << row
        end

        table_frequency = Terminal::Table.new title: 'FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010', headings: heading, rows: rows
        for c in 0..names.length do table_frequency.align_column(c,:center) end
        puts table_frequency
    end

    def self.command_check(input)
        keyword = input.split(' ')
#       options = ['-u', '--uf', '-c', '--cidade', '-f', '--frequencia', '-h', '--help', '-x', '--sair', '-d', '--dicas']

        if keyword.first == 'app'
            aux = keyword.drop(1)
            command = aux.join(' ')
            # byebug
            Parser.parse %W[#{command}]
        else
            return input
        end
    end

    private

        def self.percentage_total(location_total, name_total)
            return ((name_total.to_f / location_total.to_f) * 100).ceil(3)
        end

        def self.input_format(input)
            input.downcase!
            words = input.split(" ")
            final_word = words.map do |w|
                if w.size <= 2
                    next w.capitalize if w == 'la'  
                    next w             
                elsif w.size == 3 and (w == 'dos' or w == 'das' or w =='del')
                    next w
                else
                    w.capitalize
                end
            end
            return final_word.join(' ')
        end
end

