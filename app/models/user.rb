class User < ApplicationRecord
	before_save{self.email=email.downcase}
        VALID_EMAIL_REGEX =  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :name, presence: true, length: {minimum:6, maximum: 50 }
	validates :email, presence: true, length: {minimum:4, maximum: 255 },
 		         uniqueness:{case_sensitive: false}, format: { with: VALID_EMAIL_REGEX }
	validates :password, presence: true, length: {minimum:6, maximum:16}
     
        has_secure_password
end
