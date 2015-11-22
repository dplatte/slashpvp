class Title < ActiveRecord::Base
	belongs_to :region
	belongs_to :bracket
end
