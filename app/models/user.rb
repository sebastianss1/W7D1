class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 
    validates :password, length: { minimum: 6, allow_nil: true }
    before_validation :ensure_session_token
    
    has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

    has_many :cat_rental_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else 
            nil 
        end 
    end 

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
     end

    def reset_session_token 
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end 

    def password=(password)
        debugger
        self.password_digest = BCrypt::Password.create(password)
        @password = password 
    end 

    def password
        @password
    end 

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end 












end 