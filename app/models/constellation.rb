class Constellation < ActiveRecord::Base
 has_one :body
 attr_accessible :abbr, :constellation, :genitive
end