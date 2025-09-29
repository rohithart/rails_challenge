module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :total, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
