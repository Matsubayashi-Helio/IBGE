require 'test_helper'
require 'csv'
require 'csv_file'

describe CsvFile do
    context '.import' do
        it 'should import csv file' do
            csv_file_path = File.expand_path("db/populacao_2019.csv","#{File.dirname(__FILE__)}/../..") 
            
            csv = CsvFile.import(csv_file_path)

            expect(csv.first['Nível']).to eq('UF')
            expect(csv.first['Cód.'].to_i).to eq(11)
            expect(csv.first['Unidade da Federação']).to eq('Rondônia')
            expect(csv.first['População Residente - 2019'].to_i).to eq(1777225)
        end
    end
end