require 'optparse'
require_relative 'cli'
require 'byebug'

class Parser
    def self.parse(options)

    opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: app [options]"
        opts.separator ""
        opts.separator "Utilização da aplicação:"
        opts.on('-u [UF]', '--uf [UF]', String, "Nomes mais comuns de UF em três tabelas.", 
                                        "(Tabela de ranking geral e um de cada gênero)") do |uf|
            Cli.uf_option(uf)
        end

        opts.on("-c CIDADE", "--cidade CIDADE", String, "Nomes mais comuns de CIDADE em três tabelas.",
                                                    "(Tabela de ranking geral e um de cada gênero)") do |c|
            Cli.city_option(c)
        end

        opts.on("-f NOMES", "--frequencia NOMES", Array, "Frequência de NOMES ao longo das decadas") do |n|
            Cli.frequency_option(n)
        end
        
        opts.separator ""
        opts.separator "Opções extras:"
        opts.on_tail("-h", "--help", "Exibe todos os comandos") do
            puts opts
        end
        
        opts.on_tail("-d", "--dicas", "Dicas e informações extras") do
            Cli.tips
        end
        
        opts.on_tail('-x', '--sair', 'Sair da aplicação') do
            exit
        end
    end

    opt_parser.parse!(options)
    end
end
