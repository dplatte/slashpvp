class Talent < ActiveRecord::Base
  belongs_to :character_class
  belongs_to :character_spec
  belongs_to :spell
end
