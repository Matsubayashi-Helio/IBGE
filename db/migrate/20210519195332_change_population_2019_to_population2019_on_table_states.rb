class ChangePopulation2019ToPopulation2019OnTableStates < ActiveRecord::Migration[6.1]
  def change
    rename_column :states, :population_2019, :population2019
  end
end
