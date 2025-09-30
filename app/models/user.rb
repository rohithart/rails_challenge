class User < ApplicationRecord
  has_many :orders, dependent: :destroy

  # Task 1: ActiveRecord query optimization
  def self.with_order_counts(min: 5, since: 30.days.ago)
    left_joins(:orders)
      .where("orders.created_at >= ? OR orders.id IS NULL", since)
      .group("users.id")
      .select("users.*, COUNT(orders.id) AS orders_count")
      .having("COUNT(orders.id) > ?", min)
  end
end
