class User < ApplicationRecord
    attr_reader :password
    validates :email, presence: true, uniqueness: true
    validates :session_token, presence: true, uniqueness: {scope: :email}
    validates :password, length: {minimum: 6}, allow_nil: true
    validates :password_digest, presence: true

    before_validation :ensure_session_token

    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64
        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64
        end
        token
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        bcrypt_object = BCrypt::Password.new(password_digest)
        bcrypt_object.is_password?(password)
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        if user && user.is_password?(password)
            return user
        else
            return nil 
        end
    end



end