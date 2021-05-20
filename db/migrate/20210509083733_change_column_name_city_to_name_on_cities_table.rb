# frozen_string_literal: true

class ChangeColumnNameCityToNameOnCitiesTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :cities, :city, :name
  end
end
