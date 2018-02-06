class Contact < ApplicationRecord
  belongs_to :user

  # Validations
  validates :name, :user, presence: true

  # Kaminari configuration
  paginates_per 10

  # Associations
  has_many :addresses, dependent: :destroy

  # Nested Attributes
  accepts_nested_attributes_for :addresses, reject_if: :all_blank,
                                allow_destroy: true
end
