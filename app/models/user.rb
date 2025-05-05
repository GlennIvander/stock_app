class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :portfolios
  has_many :transactions

  # Roles
  def admin?
    is_admin
  end

  def trader?
    !is_admin
  end
end
