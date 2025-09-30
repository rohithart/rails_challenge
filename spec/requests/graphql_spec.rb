require "rails_helper"

RSpec.describe "GraphQL API", type: :request do
  let!(:user1) { create(:user, :with_orders, orders_count: 6, email: "alice@example.com") }
  let!(:user2) { create(:user, :with_orders, orders_count: 3, email: "bob@test.com") }
  let!(:user3) { create(:user, email: "charlie@example.com") }

  let(:query) do
    <<~GRAPHQL
      query($minOrders: Int, $emailDomain: String) {
        users(minOrders: $minOrders, emailDomain: $emailDomain) {
          id
          name
          email
          emailDomain
          ordersCount
          orders {
            id
            total
          }
        }
      }
    GRAPHQL
  end

  def execute_query(vars = {})
    post "/graphql", params: { query: query, variables: vars.to_json }
    JSON.parse(response.body, symbolize_names: true)[:data][:users]
  end

  before(:all) do
    User.destroy_all
  end
  
  describe "fetching users" do
    it "returns all users with orders_count and orders" do
      result = execute_query
      expect(result.size).to eq(3)

      user_data = result.find { |u| u[:email] == "alice@example.com" }
      expect(user_data[:ordersCount]).to eq(6)
      expect(user_data[:orders].size).to eq(6)
      expect(user_data[:emailDomain]).to eq("example.com")
    end
  end

  describe "filtering by minOrders" do
    it "returns only users with more than minOrders" do
      result = execute_query(minOrders: 5)
      expect(result.map { |u| u[:email] }).to contain_exactly("alice@example.com")
    end

    it "returns empty array if no users match minOrders" do
      result = execute_query(minOrders: 10)
      expect(result).to be_empty
    end
  end
end
