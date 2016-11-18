FactoryGirl.define do
  factory :user do
    user_name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password "password1"
    first_name "SampleFirstName"
    last_name "SampleLastName"
    phone_number "303-655-2554"
    company "CompanyName"
    location "SampleLocation"
    timezone "IST"
    websites "https://www.google.co.in/"
    about_me "Description of user information"
    interests "art and design"
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,'/spec/fixtures/download.jpg')))
  end
end