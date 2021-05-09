require "sinatra/activerecord"

class State < ActiveRecord::Base
    has_many :cities

    validates_presence_of :name, :uf, :location_id, :population_2019
    validates :name, :uf, :location_id, uniqueness: true
end