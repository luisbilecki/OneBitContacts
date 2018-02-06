class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Devise simple token
  acts_as_token_authenticatable

  # Relationships
  has_many :contacts, dependent: :destroy
end
