# frozen_string_literal: true

require_relative 'requester'

class StateName
  IBGE_LOCALIDADES_API_ESTADOS = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome'

  attr_reader :uf, :name, :location_id

  def initialize(name:, uf:, location_id:)
    @name = name
    @uf = uf
    @location_id = location_id
  end

  def self.states
    response = StateName.request
    response.map do |r|
      new(uf: r[:sigla], name: r[:nome], location_id: r[:id])
    end
  end

  def self.request
    api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))
    path = api['development']['base'] + api['development']['state']
    Requester.request(path)
  end
end
