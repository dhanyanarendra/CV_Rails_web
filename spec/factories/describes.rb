FactoryGirl.define do
 sequence(:title) { |n| "Clean city #{n}" }
 factory :describe do
  title
  category "land"
  short_description "short description"
  background "background"
  impact "impact"
  need "need"
  risks "risks"
  others "others"
  name "name"
  user_originator_id 1
  file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root,'/spec/fixtures/download.jpg')))
end
end
