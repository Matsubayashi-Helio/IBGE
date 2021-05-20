# frozen_string_literal: true

require 'json'

class CityName
  IBGE_LOCALIDADES_API_MUNICIPIOS = 'https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome'

  attr_reader :uf, :name, :location_id

  def initialize(uf:, name:, location_id:)
    @uf = uf
    @name = name
    @location_id = location_id
  end

  def self.cities
    response = Faraday.get(IBGE_LOCALIDADES_API_MUNICIPIOS)
    return [] if response.status != 200

    json_response = JSON.parse(response.body, symbolize_names: true)
    cities = []
    json_response.each do |r|
      cities << new(name: r[:nome], uf: r[:microrregiao][:mesorregiao][:UF][:sigla], location_id: r[:id])
    end
    # byebug
    cities
  end
end
