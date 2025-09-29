require "rails_helper"

RSpec.describe "GraphQL emailDomain filter", type: :request do
  it "filters users by emailDomain argument" do
    pending "Expose emailDomain: on users query and filter by users.email_domain"
  end

  it "combines emailDomain: with minOrders: to narrow results" do
    pending "Compose email domain filter with Task 1 min_orders"
  end
end
