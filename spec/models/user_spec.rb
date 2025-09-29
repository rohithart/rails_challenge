require "rails_helper"

RSpec.describe User, type: :model do
  describe ".with_order_counts" do
    let!(:user_with_many_orders) { create(:user, :with_orders, orders_count: 6) }
    let!(:user_with_few_orders)  { create(:user, :with_orders, orders_count: 3) }

    it "returns users with more than min orders since a given date" do
      pending "Implement .with_order_counts efficiently"
    end

    it "includes orders_count attribute" do
      pending "Add orders_count attribute to users returned"
    end

    it "avoids N+1 queries when accessing orders_count" do
      pending "Refactor to avoid N+1 queries"
    end
  end

  describe "#recent_order_totals" do
    it "returns up to 5 most recent totals without N+1/materializing full records" do
      pending "Refactor recent_order_totals implementation"
    end
  end
end
