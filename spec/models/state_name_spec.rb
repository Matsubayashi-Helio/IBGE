# frozen_string_literal: true

require 'test_helper'
require 'state_name'
require 'faraday'
require 'byebug'

describe StateName do
  stub_const('IBGE_LOCATION_API', 'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')

  context 'Fetch API Data' do
    it 'should get all states' do
      path = File.expand_path('support/get_states.json', "#{File.dirname(__FILE__)}/..")
      json = File.read(path)
      response = double('faraday_response', body: json, status: 200)
      allow(Faraday).to receive(:get)
        .with(IBGE_LOCATION_API)
        .and_return(response)

      states = StateName.states

      expect(states.size).to eq 27
      expect(states.first.uf).to eq('AC')
      expect(states.first.name).to eq('Acre')
      expect(states.first.location_id).to eq(12)
      expect(states.last.uf).to eq('TO')
      expect(states.last.name).to eq('Tocantins')
      expect(states.last.location_id).to eq(17)
    end

    it 'should return empty if cannot return data' do
      response = double('faraday_response', body: '', status: 400)
      allow(Faraday).to receive(:get)
        .with(IBGE_LOCATION_API)
        .and_return(response)
      states = StateName.states

      expect(states.length).to eq 0
    end
  end
end
