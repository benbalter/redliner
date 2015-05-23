class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :email, presence: true, unless: Proc.new { |u| u.login.present? }
  validates :login, presence: true, unless: Proc.new { |u| u.name.present? }
  validates :email, email: true, unless: Proc.new { |u| u.login.present? }

  has_many :redlines

  def promote!
    update admin: true
  end

  def demote!
    update admin: false
  end
end
