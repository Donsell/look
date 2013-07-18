 class Body < ActiveRecord::Base
  belongs_to :constellation
  has_many :observations
  has_many :catalogs
  belongs_to :body_type
  attr_accessible :body_id,
      :alt_id,
      :body_type_id,
      :constellation_id, 
      :right_ascension,
      :declination,
      :magnitude,
      :surface_brightness,
      :uranometria,
      :sky_atlas_2000,
      :pocket_sky_atlas,
      :size_max,
      :size_min,
      :position_angle,
      :class_id,
      :number_of_stars, 
      :brightest_star_mag,
      :ngc_description 
end