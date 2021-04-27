class City < ActiveRecord::Base
    belongs_to :state

    validates_presence_of :city
end