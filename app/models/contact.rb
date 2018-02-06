class Contact < ApplicationRecord
  belongs_to :user

  # Validations
  validates :name, :user, presence: true

end
