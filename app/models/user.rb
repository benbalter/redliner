class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable

  validates :name, :email, presence: true, unless: Proc.new { |u| u.login.present? }
  validates :login, presence: true, unless: Proc.new { |u| u.name.present? }
  validates :email, email: true, unless: Proc.new { |u| u.login.present? }

  has_many :redlines

  scope :admin,  -> { where(admin: true) }

  def promote!
    update admin: true
  end

  def demote!
    update admin: false
  end

  def self.from_omniauth(omniauth)
    user = User.find_or_create_by(login: omniauth.info.nickname)
    user.name  = omniauth.info.name
    user.email = omniauth.info.email
    user.admin = User.count == 1 # Make the first user an Admin
    user.save!
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.login = data["login"] if user.login.blank?
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
