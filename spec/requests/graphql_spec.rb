require "rails_helper"

RSpec.describe "GraphQL API", type: :request do
  it "fetches users and their orders with projected ordersCount" do
    pending "Implement GraphQL query for users with order counts"
  end

  it "filters users by min_orders argument" do
    pending "Add min_orders argument to GraphQL query"
  end
end
