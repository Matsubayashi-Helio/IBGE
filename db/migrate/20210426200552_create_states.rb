# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.string :state
      t.string :uf
    end
  end
end
