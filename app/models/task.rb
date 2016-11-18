class Task < ActiveRecord::Base
  default_scope {order("created_at ASC")}
  #Associations
  belongs_to :goal
  has_many :needs, dependent: :destroy

  #validations
  validates :title, :presence => true

end
