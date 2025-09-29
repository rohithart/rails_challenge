module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :orders_count, Integer, null: false
    field :orders, [Types::OrderType], null: false
  end
end
