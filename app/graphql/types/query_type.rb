module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false do
      argument :min_orders, Integer, required: false
    end

    def users(min_orders: nil)
      # TODO: Implement resolver, optionally filtering by min_orders
      User.all
    end
  end
end
