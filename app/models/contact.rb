class Contact < ApplicationRecord
  belongs_to :user

  # Validations
  validates :name, :user, presence: true

  # Kaminari configuration
  paginates_per 10
end
