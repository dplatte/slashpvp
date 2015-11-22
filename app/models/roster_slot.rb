class RosterSlot < ActiveRecord::Base
	belongs_to :team
	belongs_to :character
end
