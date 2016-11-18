class Need < ActiveRecord::Base
  belongs_to :task
  has_many :pledges, dependent: :destroy
  belongs_to :task_suggestion
  has_many :need_comments, dependent: :destroy 
end
