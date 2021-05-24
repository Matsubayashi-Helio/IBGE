# frozen_string_literal: true

class AddNotNullToCitiesAndStatesTables < ActiveRecord::Migration[6.1]
  def change
    change_column :cities, :city, :string, null: false
    change_column :cities, :location_id, :integer, null: false

    change_column :states, :state, :string, null: false
    change_column :states, :uf, :string, null: false
    change_column :states, :location_id, :integer, null: false
  end
end
