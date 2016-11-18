class Describe < ActiveRecord::Base
  default_scope {order("created_at desc")}
  #Associations
  acts_as_likeable
  acts_as_followable
  paginates_per 9
  has_many :task_suggestions, dependent: :destroy
  has_many :follows, :foreign_key => :followable_id
  has_many :likes, :foreign_key => :likeable_id
  has_many :goals, dependent: :destroy
  belongs_to :user, :class_name => 'User', :foreign_key => :user_originator_id
  has_many :comments, dependent: :destroy

  #image upload
  mount_uploader :file, AvatarUploader

  #validations
  validates :title, :presence => true
  validates :category, :presence => true
  validates_length_of :short_description, :maximum => 140
  validates :short_description, :presence => true


  def liked_user(user)
    user.likes?(self) if user.present?
  end

  def followed_user(user)
    user.follows?(self) if user.present?
  end

  def as_json(options = {})
    json_to_return = super
    if options.has_key? :user_like
      user_like = self.liked_user(options[:user_like])
      user_follow = self.followed_user(options[:user_follow])
      json_to_return[:user_like] = user_like
      json_to_return[:user_follow] = user_follow
    end
    return json_to_return
  end

end