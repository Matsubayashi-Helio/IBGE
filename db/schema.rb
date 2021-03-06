# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_519_195_504) do
  create_table 'cities', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'state_id', null: false
    t.integer 'location_id', null: false
    t.integer 'population2019'
    t.index ['location_id'], name: 'index_cities_on_location_id', unique: true
    t.index ['state_id'], name: 'index_cities_on_state_id'
  end

  create_table 'states', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'uf', null: false
    t.integer 'location_id', null: false
    t.integer 'population2019'
    t.index ['location_id'], name: 'index_states_on_location_id', unique: true
    t.index ['name'], name: 'index_states_on_name', unique: true
    t.index ['uf'], name: 'index_states_on_uf', unique: true
  end
end
