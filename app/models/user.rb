class User < ApplicationRecord
	has_many :microposts,dependent: :destroy
	attr_accessor :remember_token,:activation_token,:reset_token
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
		#"$2a$10$LHtnMk/mbWgRauQfG2reH.UhEAyGiwgMMEc5N/gSwk4V1FzApzr9S"
       end

       def User.new_token
        	SecureRandom.urlsafe_base64
       end
    
      def remember
 	   self.remember_token = User.new_token
	   update_attribute(:remember_digest,User.digest(remember_token))
      end
    
    def authenticated?(attribute, token)
	digest = send("#{attribute}_digest")
	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token)
    end
	
    def forget
		update_attribute(:remember_digest,nil)
    end

    # Activates an account.
    def activate
        update_columns(activated:true,activated_at:Time.zone.now)
    end
  
    # Sends activation email.
    def send_activation_email
           UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
	self.reset_token= User.new_token
       	update_columns(reset_digest:User.digest(reset_token),reset_sent_at:Time.zone.now)
   end
                          
    # Sends activation email.
    def send_password_reset_email
           UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
	reset_sent_at < 2.hours.ago
    end

    def feed
	Micropost.where("user_id = ?", id)
    end

  private   
       def downcase_email
	 	self.email.downcase!
	end

	# 创建并赋值激活令牌和摘要
	def create_activation_digest
		 self.activation_token = User.new_token
		 self.activation_digest = User.digest(activation_token)
	 end
end
