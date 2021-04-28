class AddLocationIdToStateAndCity < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :location_id, :integer
    add_column :cities, :location_id, :integer
  end
end
