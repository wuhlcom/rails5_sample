class User < ApplicationRecord
	attr_accessor :remember_token,:activation_token
	#before_save{self.email=email.downcase}
	before_save :downcase_email
        before_create :create_activation_digest
        VALID_EMAIL_REGEX =  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	
	validates :name, presence: true, length: {minimum:6, maximum: 50 }
	validates :email, presence: true, length: {minimum:4, maximum: 255 },
 		         uniqueness:{case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }
     
        has_secure_password
      
	validates :password, presence: true, length: {minimum:6, maximum:16},allow_nil:true

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
    
        def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
	
	def forget
		update_attribute(:remember_digest,nil)
	end
     
       def downcase_email
	 	self.email.downcase!
	end

	# 创建并赋值激活令牌和摘要
	def create_activation_digest
		 self.activation_token = User.new_token
		 self.activation_digest = User.digest(activation_token)
	 end
end
