class TaskSuggestion < ActiveRecord::Base
  default_scope {order("created_at ASC")}
  acts_as_likeable
	has_many :needs , :dependent => :destroy
	belongs_to :describe
  belongs_to :user
	validates :suggestion_title, :presence => true
  has_many :likes, :foreign_key => :likeable_id
end
