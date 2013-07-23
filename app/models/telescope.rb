class Telescope < ActiveRecord::Base
  attr_accessible :aperature, :focal_length, :manufacturer, :name, :user_id
  belongs_to :user
  validates :user_id, presence: true 
end

public

def focal_ratio
	"Need to update this function"
end
