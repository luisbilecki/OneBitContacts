class Address < ApplicationRecord
  belongs_to :contact

  # Validations
  validates_presence_of :name
end
