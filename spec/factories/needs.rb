FactoryGirl.define do
	factory :need do
		need_type "money"
		need_name "MyString"
		quantity "MyString"
		unit "MyString"
		task_id 1
		need_decription "MyString"
		priority true
	end
end
