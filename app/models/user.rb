class User < ApplicationRecord
	attr_accessor :remember_token
	before_save{self.email=email.downcase}
        VALID_EMAIL_REGEX =  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	
	validates :name, presence: true, length: {minimum:6, maximum: 50 }
	validates :email, presence: true, length: {minimum:4, maximum: 255 },
 		         uniqueness:{case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }
	validates :password, presence: true, length: {minimum:6, maximum:16}
     
        has_secure_password
      
       def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
       end

       def User.new_token
        	SecureRandom.urlsafe_base64
       end
    
       def remember
 	   self.remember_token = User.new_token
	   update_attribute(:remember_digest,User.digest(remember_token))
       end
end
