class Order < ApplicationRecord
  belongs_to :user

  # Task 2: Validations & scopes
  # TODO: Validate total > 0
  # TODO: Scope `.high_value` for orders with total > 100
end
