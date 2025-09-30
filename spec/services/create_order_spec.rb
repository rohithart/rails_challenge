require "rails_helper"

class SomeJob; end

RSpec.describe "CreateOrder Service / SolidQueue" do
  let(:user) { create(:user) }
  let(:order_params) { { user: user, total: 200 } }
  let(:invalid_params) { { user: user, total: 0 } }

  before do
    stub_const("SomeJob", Class.new) 
    stub_const("SolidQueue", Class.new do 
      def self.enqueue(job_class, *args); end 
    end)
    allow(SolidQueue).to receive(:enqueue)
  end

  describe "enqueuing orders" do
    it "enqueues a new order job after successful creation" do
      result = CreateOrder.new(**order_params).call

      expect(result.success?).to be true
      expect(result.order).to be_persisted
      expect(SolidQueue).to have_received(:enqueue).with(SomeJob, result.order.id)
    end
  end

  describe "processing invalid orders" do
    it "does not create an order if total is invalid" do
      result = CreateOrder.new(**invalid_params).call

      expect(result.success?).to be false
      expect(result.order).to be_nil
      expect(result.errors).to include("Total must be greater than 0")
      expect(SolidQueue).not_to have_received(:enqueue)
    end
  end

  describe "associating order with the correct user" do
    it "creates an order belonging to the specified user" do
      result = CreateOrder.new(**order_params).call
      expect(result.order.user_id).to eq(user.id)
    end
  end

  describe "error handling" do
    it "returns errors if an exception occurs during save" do
      allow_any_instance_of(Order).to receive(:save!).and_raise(StandardError, "DB error")
      result = CreateOrder.new(**order_params).call

      expect(result.success?).to be false
      expect(result.errors).to include("DB error")
    end
  end
end
