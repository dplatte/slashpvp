class Team < ActiveRecord::Base
	has_many :roster_slots
    has_many :teams, :through => :roster_slots
end
