# frozen_string_literal: true

require 'sinatra/activerecord'

class State < ActiveRecord::Base
  has_many :cities

  validates_presence_of :name, :uf, :location_id
  validates :name, :uf, :location_id, uniqueness: true
end
