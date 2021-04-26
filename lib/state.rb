class State < ActiveRecord::Base
    validates_presence_of :state, :initials
end