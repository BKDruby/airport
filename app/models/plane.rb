class Plane < ActiveRecord::Base
  has_many :histories

  enum status: { hangar: 0, on_take_of: 1, flew_away: 2 }
end
