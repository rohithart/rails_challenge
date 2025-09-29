class User < ApplicationRecord
  has_many :orders, dependent: :destroy

  # Task 1: ActiveRecord query optimization
  # TODO: Implement `.with_order_counts(min:, since:)` efficiently using SQL (joins/group/having)
  # Current naive implementation is intentionally inefficient and causes N+1 work in callers.
  def self.with_order_counts(min: 5, since: 30.days.ago)
    all.select { |u| u.orders.where("created_at >= ?", since).count > min }
  end

  # For Task 4 (Debugging / Performance)
  # Inefficient version below; refactor in the exercise to an eager/preloaded, DB-driven approach.
  def recent_order_totals
    orders.last(5).map(&:total)
  end
end
