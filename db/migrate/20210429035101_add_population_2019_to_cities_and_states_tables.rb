# frozen_string_literal: true

class AddPopulation2019ToCitiesAndStatesTables < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :population_2019, :integer
    add_column :cities, :population_2019, :integer
  end
end
