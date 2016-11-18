class Comment < ActiveRecord::Base
  default_scope {order("created_at DESC")}
  belongs_to :user
  belongs_to :describe

  #validations

  validates :comment_body, :presence => true
end
