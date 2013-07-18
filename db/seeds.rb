# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.add_role :admin
Constellation.delete_all
open ("public/data/constellations.csv") do |constellations|
  constellations.read.each_line do |constellation|
    abbr, name, genitive = constellation.chomp.split(",")
    Constellation.create!(:abbr => abbr.humanize, :constellation => name.humanize, :genitive => genitive.humanize)
  end
end


BodyType.delete_all
open ("public/data/object_types.txt") do |types|
  types.read.each_line do |type|
    abbr, name = type.chomp.split(",")
    BodyType.create!(:abbr => abbr, :description => name)
  end
end
#=end
#=begin 
Body.delete_all
Catalog.delete_all

open ("public/data/bodies.csv") do |bodies|
  bodies.read.each_line do |body|
    object_id, alt_id, type, constellation, ra, dec, mag, sb, ur, sa2000, max, min, angle, class_id, numstars, bs, bchm, ngc = body.squeeze(" ").chomp.split(",")
    sec = (ra[6].to_i * 6).to_s
    ra.gsub!(/\s/ ,":")
    ra = "2000-01-01 " + ra.chop.chop + ":" + sec
    dec.gsub!(/\s/, ".")
    if type.chr.to_i != 0  then 
      numstars = type.chr.to_i
    end 
    type.sub!(/\d/, '#')
    btype = BodyType.where(:abbr => type)
    cnst = Constellation.where(:abbr => constellation.humanize)
    ra_dec = ra.to_time.hour + (ra.to_time.min/60)
    case ra.to_time.hour
    when 0..2
      base_page = 1
      median = 1.5
    when 3..5
      base_page = 11
      median = 4.5
    when 6..8
      base_page = 21
      median = 7.5
    when 9..11
      base_page = 31
      median = 9.5
    when 12..14
      base_page = 41
      median = 13.5
    when 15..17
      base_page = 51
      median = 16.5
    when 18..20
      base_page = 61
      median = 19.5
    when 21..23
      base_page = 71
      median = 22.5
    end
    
    case dec.to_f
    when -89.99..-60.0
      psa_page = base_page + 9
    when -60.00..-30.0
      if ra_dec < median
        psa_page = base_page + 8
      else
        psa_page = base_page + 7
      end
    when -30.0..0.0
      if ra_dec < median + 0.33
        psa_page = base_page + 6
      else
        psa_page = base_page + 5
      end
    when 0.0..30.0
      if ra_dec < median + 0.33
        psa_page = base_page + 4
      else
        psa_page = base_page + 3
      end
    when 30.0..60.0
      if ra_dec < median + 0.33
        psa_page = base_page + 2
      else
        psa_page = base_page + 1
      end
    else
      psa_page = base_page
    end
     body = Body.create!(
      :body_id => object_id,
      :alt_id => alt_id,
      :body_type_id => btype.first.id,
      :constellation_id => cnst.first.id, 
      :right_ascension => ra,
      :declination => dec,
      :magnitude => mag,
      :surface_brightness => sb,
      :uranometria => ur,
      :sky_atlas_2000 => sa2000,
      :pocket_sky_atlas => psa_page,
      :size_max => max,
      :size_min => min,
      :position_angle => angle,
      :class_id => class_id,
      :number_of_stars => numstars, 
      :brightest_star_mag => bs,
      :ngc_description => ngc, 
    )
    body_array = object_id.split(';')
    body_array.each do |entry|
      entry.squeeze!(" ") 
      entry.sub!("V V", "VV")
      entry.sub!("- ", "-")
      entry.sub!("- ", "-")
      entry.sub!(". ", ".")
      entry.sub!(". ", ".")
      entry.sub!("Sh2-", "Sh2 ")
      entry_array = entry.split
      Catalog.create!(
        :catalog => entry_array[0],
        :catalog_num => entry_array[1],
        :body_id => body.id,
      )
    end
    body_array = alt_id.split(';')
    body_array.each do |entry|
      entry.squeeze!(" ")
      entry.sub!("V V", "VV")
      entry.sub!("- ", "-")
      entry.sub!("- ", "-")
      entry.sub!("- ", "-")
      entry.sub!(". ", ".")
      entry.sub!("Sh2-", "Sh2 ")
      entry_array = entry.split
      if entry_array.length > 1
        Catalog.create!(
          :catalog => entry_array[0],
          :catalog_num => entry_array[1],
          :body_id => body.id,
        )
      end
    end
  end
end