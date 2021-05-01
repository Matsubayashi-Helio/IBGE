require 'optparse'

class Test
    def self.test
        puts 'Hello!, this is a test'
    end
end

OptionParser.new do |opt|
    opt.banner = "Usage app.rb [options]"
    opt.on("-uf", "Mostra uma lista de todos os estados e exibe nomes mais comuns de UF selecionada") do
        puts 'OPÇÃO UF'
    end
    
    opt.on("-c", "--cidade", "Exibe nomes mais comuns de cidade selecionada") do
        puts 'OPÇÃO CIDADE'
    end
    
    opt.on("-freq", "--frequencia", "Exibe nomes mais comuns ao longo das decadas") do
        puts 'OPÇÃO FREQUENCIA'
    end
    
    opt.on("-h", "--help", "Exibe ajuda") do
        puts opt
        # exit
    end
    
    opt.on("-t", "--test", "This is a test") do
        Test.test
        # exit
    end
end.parse!

# p ARGV


