require "sinatra/activerecord"

class State < ActiveRecord::Base
    has_many :cities

    validates_presence_of :state, :uf, :location_id, :population_2019
    validates :state, :uf, :location_id, uniqueness: true
end