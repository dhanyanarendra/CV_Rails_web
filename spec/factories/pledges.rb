FactoryGirl.define do
	factory :pledge do
		user
		pledge_content 'abcd'
		pledged true
		quantity 6
	end

end
