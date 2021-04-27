class CityName

    attr_reader :uf, :city

    def initialize(uf:, city:)
        @uf = uf
        @city = city
    end

    def self.cities
        response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        cities = []
        json_response.each do |r|
            cities << new(city: r[:nome], uf: r[:microrregiao][:mesorregiao][:UF][:sigla] )
        end
        # byebug
        return cities
    end

end