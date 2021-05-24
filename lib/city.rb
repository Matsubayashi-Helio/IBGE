# frozen_string_literal: true

class City < ActiveRecord::Base
  belongs_to :state

  validates_presence_of :name, :location_id
  validates :location_id, uniqueness: true
end
