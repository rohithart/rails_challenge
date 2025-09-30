module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false do
      argument :min_orders, Integer, required: false
      argument :email_domain, String, required: false
    end

    def users(min_orders: nil, email_domain: nil)
      relation = min_orders.present? ? User.with_order_counts(min: min_orders, since: 30.days.ago) : User.all
      relation = relation.where(email_domain: email_domain.downcase) if email_domain.present?
      relation
    end
  end
end
