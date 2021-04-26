require 'spec_helper'
require 'state_name'
require 'faraday'
require 'byebug'


describe StateName do
    context 'Fetch API Data' do
        it 'should get all states' do
            path = File.expand_path("support/get_states.json","#{File.dirname(__FILE__)}/..") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get)
                        .with('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
                        .and_return(response)

            states = StateName.states

            expect(states.size).to eq 27
            expect(states.first.initials).to eq('AC')
            expect(states.first.state).to eq('Acre')            
            expect(states.last.initials).to eq('TO')
            expect(states.last.state).to eq('Tocantins')
        end

        it 'should return empty if cannot return data' do
            response = double('faraday_response', body: '', status: 400)
            allow(Faraday).to receive(:get)
                        .with('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
                        .and_return(response)
            states = StateName.states

            expect(states.length).to eq 0
        end
    end
end