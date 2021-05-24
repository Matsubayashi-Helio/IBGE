# frozen_string_literal: true

class AddUniqueValueToCitiesAndStatesTables < ActiveRecord::Migration[6.1]
  def change
    add_index :cities, :location_id, unique: true

    add_index :states, :location_id, unique: true
    add_index :states, :state, unique: true
    add_index :states, :uf, unique: true
  end
end
