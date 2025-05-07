class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

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
