require "rails_helper"

RSpec.describe "GraphQL emailDomain filter", type: :request do
  let!(:user1) { create(:user, :with_orders, orders_count: 6, email: "alice@example.com") }
  let!(:user2) { create(:user,:with_orders, orders_count: 6, email: "bob@test.com") }
  let!(:user3) { create(:user, email: "charlie@example.com") }


  let(:query) do
    <<~GRAPHQL
      query($minOrders: Int, $emailDomain: String) {
        users(minOrders: $minOrders, emailDomain: $emailDomain) {
          email
          emailDomain
          ordersCount
        }
      }
    GRAPHQL
  end

  def execute_query(vars = {})
    post "/graphql", params: { query: query, variables: vars.to_json }
    JSON.parse(response.body, symbolize_names: true)[:data][:users]
  end

  describe "filtering by emailDomain" do
    it "returns users with matching email domain" do
      result = execute_query(emailDomain: "example.com")
      emails = result.map { |u| u[:email] }
      expect(emails).to contain_exactly("alice@example.com", "charlie@example.com")
    end

    it "is case-insensitive" do
      result = execute_query(emailDomain: "EXAMPLE.COM")
      emails = result.map { |u| u[:email] }
      expect(emails).to contain_exactly("alice@example.com", "charlie@example.com")
    end

    it "returns empty array if no matching domain" do
      result = execute_query(emailDomain: "nonexistent.com")
      expect(result).to be_empty
    end
  end

  describe "combining emailDomain with minOrders" do
    it "returns only users satisfying both filters" do
      result = execute_query(emailDomain: "example.com", minOrders: 1)
      emails = result.map { |u| u[:email] }
      expect(emails).to contain_exactly("alice@example.com")
    end
  end
end
