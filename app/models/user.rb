class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :charters
  has_many :clients
  has_many :orders
  has_many :products
  has_many :providers
  has_many :services
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end