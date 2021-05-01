class City < ActiveRecord::Base
    belongs_to :state

    validates_presence_of :city, :location_id
    validates :location_id, uniqueness: true
end