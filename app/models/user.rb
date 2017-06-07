class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token
	before_save{email.downcase!} #self.email.downcase. Before_save can take a block or a method
  before_create :create_activation_digest

	validates(:name, presence:true, length: {maximum:50})
	  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence:true, length: {maximum:255},
			          format: {with: VALID_EMAIL_REGEX}, 
	 				  uniqueness: { case_sensitive: false }

	 validates :password, length:{minimum:6},presence:true,allow_nil: true

	 has_secure_password

class << self #To define class methods. Same as == User.digest || self.digest
 # Returns the hash digest of the given string.
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def new_token
  	SecureRandom.urlsafe_base64
  end

end

  # Remembers a user in the database for use in persistent sessions.
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end
  # Returns true if the given token matches the digest.
  def authenticated?(attribute,token)
    digest = self.send("#{attribute}_digest")# self is optional here because we are inside the user model
  	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token) #remember_digest same as self.remember_digest
  end



  #forget a user
  def forget
  	update_attribute(:remember_digest,nil)
  end

 def activate
  update_columns(activated:true,activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end



  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

 

end
