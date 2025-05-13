class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :portfolios
  has_many :transactions, through: :portfolios

  # Roles
  def admin?
    is_admin
  end

  def trader?
    !is_admin
  end

  validate :password_complexity

  def password_complexity
    return if password.blank?

    unless password =~ /[^A-Za-z0-9]/
      errors.add :password, 'must include at least one special character (e.g., !@#$%^&*)'
    end
  end
end
