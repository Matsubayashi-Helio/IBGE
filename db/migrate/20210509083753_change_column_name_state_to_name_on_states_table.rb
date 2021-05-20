# frozen_string_literal: true

class ChangeColumnNameStateToNameOnStatesTable < ActiveRecord::Migration[6.1]
  def change
    rename_column :states, :state, :name
  end
end
