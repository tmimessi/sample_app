class User < ApplicationRecord
    # arranges for the dependent microposts to be destroyed when the user itself is destroyed
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, 
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    # returns the hash digest of the given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # returns a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # remembers a user in the database for use in persistent sessions
    def remember 
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    # returns a session token to prevent session hijacking 
    # reusing the remember digest for convenience
    def session_token
        remember_digest || remember
    end

    # returns true if the given token matches the digest
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end

    # activates an account
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
    
    # sends activation email
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    # sets the password reset attributes
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

    # sends password reset email
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # returns true if a password reset has expired
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # returns a users status feed
    def feed
       part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
       Micropost.left_outer_joins(user: :followers)
       .where(part_of_feed, { id: id }).distinct
        .includes(:user, image_attachment: :blob)
    end

    # follows a user
    def follow(other_user)
        following << other_user unless  self == other_user
    end

    # unfollows a user 
    def unfollow(other_user)
        following.delete(other_user)
    end

    # returns true if the current user is following the other user
    def following?(other_user)
        following.include?(other_user)
    end

    private
    # converts email to all lowercase
    def downcase_email
        email.downcase!
    end
    
    # creates and assigns the activation token and digest
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
