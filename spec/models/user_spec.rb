require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:orders).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("test@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
  end

  describe "callbacks" do
    it "normalizes email before validation" do
      user = build(:user, email: "  TEST@Example.COM  ")
      user.valid?
      expect(user.email).to eq("test@example.com")
    end
  end

  describe ".with_order_counts" do
    before(:all) do
      @recent_time = 15.days.ago

      @user_with_many_orders = create(:user, :with_orders, orders_count: 6)
      @user_with_many_orders.orders.update_all(created_at: 1.day.ago)
      @user_with_few_orders = create(:user, :with_orders, orders_count: 3)
      @user_with_no_orders = create(:user)
    end

    context "when filtering by minimum order count" do
      it "includes users with more than min orders in the date range" do
        results = User.with_order_counts(min: 5, since: 30.days.ago)
        expect(results).to include(@user_with_many_orders)
      end

      it "excludes users with equal or fewer orders than min" do
        results = User.with_order_counts(min: 5, since: 30.days.ago)
        expect(results).not_to include(@user_with_few_orders)
      end

      it "excludes users with no orders" do
        results = User.with_order_counts(min: 5, since: 30.days.ago)
        expect(results).not_to include(@user_with_no_orders)
      end
    end

    context "when including orders_count in select" do
      it "adds orders_count attribute to returned users" do
        results = User.with_order_counts(min: 5, since: 30.days.ago)
        user = results.find { |u| u.id == @user_with_many_orders.id }
        expect(user.orders_count).to eq(6)
      end
    end
  end

  describe "#recent_order_totals" do
    let(:user) { create(:user) }

    before do
      @orders = [
        create(:order, user: user, total: 50, created_at: 1.day.ago),
        create(:order, user: user, total: 150, created_at: 2.days.ago),
        create(:order, user: user, total: 300, created_at: 3.days.ago),
        create(:order, user: user, total: 500, created_at: 4.days.ago),
        create(:order, user: user, total: 700, created_at: 5.days.ago),
        create(:order, user: user, total: 900, created_at: 6.days.ago)
      ]
    end

    it "returns the 5 most recent totals in descending order" do
      expect(user.recent_order_totals).to eq([50, 150, 300, 500, 700])
    end

    it "returns fewer results if less than 5 orders exist" do
      other_user = create(:user)
      create(:order, user: other_user, total: 123)
      expect(other_user.recent_order_totals).to eq([123])
    end

    it "uses pluck to avoid loading full order records" do
      expect(user.orders).not_to receive(:map)
      user.recent_order_totals
    end
  end

  describe "integration of normalization and uniqueness" do
    it "treats emails case-insensitively for uniqueness" do
      create(:user, email: "Test@Example.com")
      dup_user = build(:user, email: "test@example.com")
      expect(dup_user).not_to be_valid
      expect(dup_user.errors[:email]).to include("has already been taken")
    end
  end
end
