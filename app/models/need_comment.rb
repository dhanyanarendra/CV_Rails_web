class NeedComment < ActiveRecord::Base
  default_scope {order("created_at DESC")}
  belongs_to :user
  belongs_to :need

#validations

  validates :body_description, :presence => true
end
