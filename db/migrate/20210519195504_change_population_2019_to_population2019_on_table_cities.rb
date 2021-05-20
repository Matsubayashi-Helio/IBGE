class ChangePopulation2019ToPopulation2019OnTableCities < ActiveRecord::Migration[6.1]
  def change
    rename_column :cities, :population_2019, :population2019
  end
end
