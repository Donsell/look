class BodyType < ActiveRecord::Base
  has_one :body
  attr_accessible :abbr, :description
end