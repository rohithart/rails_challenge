module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :email_domain, String, null: false
    field :orders_count, Integer, null: false
    field :orders, [Types::OrderType], null: false

    def email_domain
      object.email_domain.presence || object.email.to_s.split("@").last&.downcase
    end

    def orders_count
      if object.respond_to?(:orders_count)
        object.orders_count.to_i
      else
        object.association(:orders).loaded? ? object.orders.size : object.orders.count
      end
    end
  end
end
