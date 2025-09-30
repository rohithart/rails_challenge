require "rails_helper"

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    context "when total is valid" do
      it "allows positive totals" do
        order = build(:order, user: user, total: 10.5)
        expect(order).to be_valid
      end
    end

    context "when total is invalid" do
      it "rejects total of 0" do
        order = build(:order, user: user, total: 0)
        expect(order).not_to be_valid
        expect(order.errors[:total]).to include("must be greater than 0")
      end

      it "rejects negative totals" do
        order = build(:order, user: user, total: -50)
        expect(order).not_to be_valid
        expect(order.errors[:total]).to include("must be greater than 0")
      end

      it "rejects nil totals" do
        order = build(:order, user: user, total: nil)
        expect(order).not_to be_valid
        expect(order.errors[:total]).to include("is not a number")
      end
    end
  end

  describe ".high_value" do
    before(:all) do
      @user = create(:user)
      @low_value_order = create(:order, user: @user, total: 50)
      @borderline_order = create(:order, user: @user, total: 100)
      @high_value_order = create(:order, user: @user, total: 150)
    end

    it "includes orders with total greater than 100" do
      result = Order.high_value
      expect(result).to include(@high_value_order)
    end

    it "excludes orders with total equal to 100" do
      result = Order.high_value
      expect(result).not_to include(@borderline_order)
    end

    it "excludes orders with total less than 100" do
      result = Order.high_value
      expect(result).not_to include(@low_value_order)
    end
  end

  describe "integration of validation and scope" do
    context "when trying to save invalid orders" do
      it "does not appear in .high_value scope if invalid" do
        invalid_order = Order.create(user: user, total: -500)
        expect(Order.high_value).not_to include(invalid_order)
      end
    end
  end
end
