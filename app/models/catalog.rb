class Catalog < ActiveRecord::Base
  belongs_to :body
  attr_accessible :catalog,
        :catalog_num,
        :body_id

    def designation
    	"#{self.catalog} #{self.catalog_num}"
	end
end
