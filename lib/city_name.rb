# frozen_string_literal: true

require_relative 'requester'

class CityName
  attr_reader :uf, :name, :location_id

  def initialize(uf:, name:, location_id:)
    @uf = uf
    @name = name
    @location_id = location_id
  end

  def self.cities
    response = CityName.request
    response.map do |r|
      new(name: r[:nome], uf: r[:microrregiao][:mesorregiao][:UF][:sigla], location_id: r[:id])
    end
  end

  def self.request
    api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))
    path = api['development']['base'] + api['development']['city']
    Requester.request(path)
  end
end
