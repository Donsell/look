class Catalog < ActiveRecord::Base
  belongs_to :body
  attr_accessible :catalog,
        :catalog_num,
        :body_id
end
