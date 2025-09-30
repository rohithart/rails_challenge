class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  
  before_validation :normalize_email
  before_validation :set_email_domain

  validates :email, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "is invalid" }
  validates :email, uniqueness: { case_sensitive: false }

  # Task 1: ActiveRecord query optimization
  def self.with_order_counts(min: 5, since: 30.days.ago)
    left_joins(:orders)
      .where("orders.created_at >= ? OR orders.id IS NULL", since)
      .group("users.id")
      .select("users.*, COUNT(orders.id) AS orders_count")
      .having("COUNT(orders.id) > ?", min)
  end

  # For Task 4 (Debugging / Performance)
  def recent_order_totals(limit: 5)
    orders.order(created_at: :desc).limit(limit).pluck(:total)
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase.presence
  end

  def set_email_domain
    self.email_domain = email.to_s.split('@').last&.downcase if email.present?
  end
end
