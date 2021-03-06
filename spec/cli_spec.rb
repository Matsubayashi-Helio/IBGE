# frozen_string_literal: true

require 'cli'
require 'faraday'
require 'name'
require 'byebug'
require 'json'
require 'stringio'
require 'test_helper'

describe Cli do
  context 'User input' do
    it '.user_input_uf' do
      io = StringIO.new
      io.puts 'SP'
      io.rewind
      $stdin = io

      input_uf = Cli.user_input_uf
      expect(input_uf).to eq 'SP'

      $stdin = STDIN
    end

    it '.input_city_name' do
      io = StringIO.new
      io.puts 'são paulo'
      io.rewind
      $stdin = io

      input_uf = Cli.user_input_uf
      expect(input_uf).to eq 'são paulo'

      $stdin = STDIN
    end

    it '.input_names' do
      io = StringIO.new
      io.puts 'joao, maria'
      io.rewind
      $stdin = io

      path = File.expand_path('support/get_names_frequency.json', File.dirname(__FILE__).to_s)
      json = File.read(path)
      response = double('faraday_response', body: json, status: 200)
      api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

      path_api = api['test']['base'] + api['test']['frequency']

      api_path_frequency = "#{path_api}joao%7Cmaria"
      allow(Faraday).to receive(:get).with(api_path_frequency).and_return(response)

      names = Cli.input_names
      expect(names.first[:nome]).to eq 'JOAO'
      expect(names.first[:res].first[:periodo]).to eq '1930['
      expect(names.first[:res].first[:frequencia]).to eq 60_155
      expect(names.first[:res].last[:periodo]).to eq '[2000,2010['
      expect(names.first[:res].last[:frequencia]).to eq 794_118
      expect(names.last[:nome]).to eq 'MARIA'
      expect(names.last[:res].first[:periodo]).to eq '1930['
      expect(names.last[:res].first[:frequencia]).to eq 336_477
      expect(names.last[:res].last[:periodo]).to eq '[2000,2010['
      expect(names.last[:res].last[:frequencia]).to eq 1_111_301

      $stdin = STDIN
    end
  end

  context 'show tables for the user' do
    context '.show_names_by_uf' do
      it 'return false if nothing goes wrong' do
        create(:state, uf: 'RJ')

        allow(Name).to receive(:rank_by_location).and_return([])
        uf = Cli.show_names_by_uf('RJ')

        expect(uf).to eq false
      end

      it 'return true if uf do not exist' do
        uf = Cli.show_names_by_uf('RJ')
        expect(uf).to eq true
      end
    end

    context '.show_names_by_city' do
      it 'return false if nothing goes wrong' do
        uf_rj = create(:state)
        create(:city, name: 'Rio de Janeiro', state: uf_rj)

        allow(Name).to receive(:rank_by_location).and_return([])
        city = Cli.show_names_by_city('Rio de Janeiro')

        expect(city).to eq false
      end

      it 'return true if city do not exist' do
        city = Cli.show_names_by_city('Paris')
        expect(city).to eq true
      end

      it 'show names frequency by decade' do
        path = File.expand_path('support/get_names_frequency.json', File.dirname(__FILE__).to_s)
        json = File.read(path)
        response = double('faraday_response', body: json, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['frequency']
        api_path_frequency = "#{path_api}joao%7Cmaria"

        allow(Faraday).to receive(:get).with(api_path_frequency).and_return(response)

        names_joao_and_maria = JSON.parse(json, symbolize_names: true)

        expect { Cli.show_names_frequency(names_joao_and_maria) }.to output(
          include('| PERÍODO     | JOAO        | MARIA      |',
                  '|   < 1930    |    60155    |   336477   |',
                  '|    2000     |   794118    |  1111301   |')
        ).to_stdout
      end
    end

    context '.show_table' do
      it 'shows table with rank of the most common names for uf' do
        rj = create(:state, location_id: 33)

        path = File.expand_path('support/get_names_by_uf.json', File.dirname(__FILE__).to_s)
        json = File.read(path)
        response = double('faraday_response', body: json, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_rank = path_api + rj.location_id.to_s
        allow(Faraday).to receive(:get).with(api_path_rank).and_return(response)

        expect { Cli.show_table(rj) }.to output(include('| RANK | NOME     | FREQUENCIA | % RELATIVA |',
                                                        '| 1    | MARIA    | 752021     | 4.356      |',
                                                        '| 20   | RODRIGO  | 70436      | 0.408      |')).to_stdout
      end

      it 'shows table with rank of the most common female names for uf' do
        rj = create(:state, location_id: 33)

        path_f = File.expand_path('support/get_names_by_uf_and_gender_F.json', File.dirname(__FILE__).to_s)
        json_f = File.read(path_f)
        response_f = double('faraday_response', body: json_f, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_f = path_api + "#{rj.location_id}&sexo=F"
        allow(Faraday).to receive(:get).with(api_path_f).and_return(response_f)

        expect do
          Cli.show_table(rj, 'F')
        end.to output(include('| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |',
                              '| 1         | MARIA    | 749527     | 4.342      |',
                              '| 20        | LETICIA  | 40526      | 0.235      |')).to_stdout
      end

      it 'shows table with rank of the most common male names for uf' do
        rj = create(:state, location_id: 33)

        path_m = File.expand_path('support/get_names_by_uf_and_gender_M.json', File.dirname(__FILE__).to_s)
        json_m = File.read(path_m)
        response_m = double('faraday_response', body: json_m, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_m = path_api + "#{rj.location_id}&sexo=M"
        allow(Faraday).to receive(:get).with(api_path_m).and_return(response_m)

        expect do
          Cli.show_table(rj, 'M')
        end.to output(include('| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |',
                              '| 1         | JOSE      | 312855     | 1.813      |',
                              '| 20        | FELIPE    | 67505      | 0.391      |')).to_stdout
      end

      it 'shows table with rank of the most common names for city' do
        uf_rj = create(:state)
        city_rj = create(:city, name: 'Rio de Janeiro', location_id: 3_304_557, population2019: 6_718_903,
                                state: uf_rj)

        path = File.expand_path('support/get_names_by_city.json', File.dirname(__FILE__).to_s)
        json = File.read(path)
        response = double('faraday_response', body: json, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_rank = path_api + city_rj.location_id.to_s
        allow(Faraday).to receive(:get).with(api_path_rank).and_return(response)

        expect { Cli.show_table(city_rj) }.to output(
          include('| RANK | NOME      | FREQUENCIA | % RELATIVA |',
                  '| 1    | MARIA     | 307018     | 4.57       |',
                  '| 3    | JOSE      | 118239     | 1.76       |',
                  '| 20   | ANDRE     | 30387      | 0.453      |')
        )
          .to_stdout
      end

      it 'shows table with rank of the most common female names for city' do
        uf_rj = create(:state)
        city_rj = create(:city, name: 'Rio de Janeiro', location_id: 3_304_557, population2019: 6_718_903,
                                state: uf_rj)

        path_f = File.expand_path('support/get_names_by_city_and_gender_F.json', File.dirname(__FILE__).to_s)
        json_f = File.read(path_f)
        response_f = double('faraday_response', body: json_f, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_f = path_api + "#{city_rj.location_id}&sexo=F"
        allow(Faraday).to receive(:get).with(api_path_f).and_return(response_f)

        expect do
          Cli.show_table(city_rj, 'F')
        end.to output(include('| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |',
                              '| RANK      | NOME     | FREQUENCIA | % RELATIVA |',
                              '| 1         | MARIA    | 305973     | 4.554      |',
                              '| 20        | LUCIA    | 16596      | 0.248      |')).to_stdout
      end

      it 'shows table with rank of the most common female names for city' do
        uf_rj = create(:state)
        city_rj = create(:city, name: 'Rio de Janeiro', location_id: 3_304_557, population2019: 6_718_903,
                                state: uf_rj)

        path_m = File.expand_path('support/get_names_by_city_and_gender_M.json', File.dirname(__FILE__).to_s)
        json_m = File.read(path_m)
        response_m = double('faraday_response', body: json_m, status: 200)
        api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

        path_api = api['test']['base'] + api['test']['rank']

        api_path_m = path_api + "#{city_rj.location_id}&sexo=M"
        allow(Faraday).to receive(:get).with(api_path_m).and_return(response_m)

        expect do
          Cli.show_table(city_rj, 'M')
        end.to output(include('| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |',
                              '| RANK      | NOME      | FREQUENCIA | % RELATIVA |',
                              '| 1         | JOSE      | 117746     | 1.753      |',
                              '| 20        | FELIPE    | 29093      | 0.434      |')).to_stdout
      end
    end

    it '.show_names_frequency' do
      path = File.expand_path('support/get_names_frequency.json', File.dirname(__FILE__).to_s)
      json = File.read(path)
      response = double('faraday_response', body: json, status: 200)
      api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

      path_api = api['test']['base'] + api['test']['frequency']

      api_path_frequency = "#{path_api}joao%7Cmaria"
      allow(Faraday).to receive(:get).with(api_path_frequency).and_return(response)

      names = 'joao, maria'
      api_names = Name.names_frequency(names)

      expect do
        Cli.show_names_frequency(api_names)
      end.to output(include('| FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010 |',
                            '| PERÍODO     | JOAO        | MARIA      |',
                            '|   < 1930    |    60155    |   336477   |',
                            '|    2000     |   794118    |  1111301   |')).to_stdout
    end

    it '.show_ufs' do
      State.create(name: 'Acre', uf: 'AC', location_id: 12, population2019: 881_935)
      State.create(name: 'Tocantins', uf: 'TO', location_id: 17, population2019: 1_572_866)

      expect { Cli.show_ufs }.to output(include('UF | ESTADO', 'AC | Acre', 'TO | Tocantins')).to_stdout
    end
  end
end
