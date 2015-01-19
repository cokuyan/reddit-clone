class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: { message: "Password can't be blank" }

  after_initialize :ensure_session_token

  has_many :subs,
    class_name: 'Sub',
    foreign_key: :moderator_id,
    dependent: :destroy

  has_many :posts,
    class_name: 'Post',
    foreign_key: :author_id,
    dependent: :destroy

  has_many :comments,
    class_name: 'Comment',
    foreign_key: :author_id,
    dependent: :destroy

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
