class Order < ApplicationRecord
  belongs_to :user

  # Task 2: Validations & scopes
  validates :total, numericality: { greater_than: 0 }
  scope :high_value, -> { where("total > ?", 100) }
end
