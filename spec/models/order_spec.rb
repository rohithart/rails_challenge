require "rails_helper"

RSpec.describe Order, type: :model do
  describe "validations" do
    it "rejects orders with non-positive totals" do
      pending "Add numericality validation for total > 0"
    end
  end

  describe ".high_value" do
    it "returns only orders with total > 100" do
      pending "Add scope .high_value"
    end
  end
end
