class User < ActiveRecord::Base
  acts_as_liker
  acts_as_follower
  has_secure_password
  acts_as_followable

  # Callbacks
  before_validation :generate_auth_token,on: :create

  #associations
  has_many :describes, :foreign_key => :user_originator_id, :dependent => :destroy
  has_many :pledges, :dependent => :destroy, :foreign_key => :user_contributor_id
  has_many :task_suggestions
  has_many :follows, :foreign_key => :followable_id
  has_many :comments

  #image upload
  mount_uploader :file, AvatarUploader

  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:password_digest, :created_at, :updated_at]

  #Validations
  validates :user_name, :presence => true,:uniqueness =>  {:case_sensitive => false}
  validates :email, :presence => true,:uniqueness => {:case_sensitive => false},format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: "Not a valid email Address" }
  validates :password, :presence => true, format: { without: /\s/ ,message: "Your password can't contain spaces" }, :unless => lambda {|u| u.password.nil? }
  validates_length_of :password, :minimum => 8, :unless => lambda {|u| u.password.nil? }
  validates_length_of :user_name, :minimum => 8

  # Instance Methods
  def as_json(options={})
    options[:except] ||= EXCLUDED_JSON_ATTRIBUTES
    super(options)
  end

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
  end

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
      self.password_reset_sent_at = Time.current
      save(validate: false)
    end
  end

end
