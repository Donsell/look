# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :telescope do
    user_id ""
    name "MyString"
    manufacturer "MyString"
    focal_length ""
    aperature ""
  end
end
