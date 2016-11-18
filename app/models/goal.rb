class Goal < ActiveRecord::Base

  #Associations
  has_many :tasks, dependent: :destroy
  belongs_to :describe

  #validations
	validates :title, :presence => true
end
