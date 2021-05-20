# frozen_string_literal: true

class CreateCity < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :city
      t.belongs_to :state, null: false
    end
  end
end
