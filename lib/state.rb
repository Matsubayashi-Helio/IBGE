require "sinatra/activerecord"

class State < ActiveRecord::Base
    has_many :cities

    validates_presence_of :state, :uf, :location_id
end