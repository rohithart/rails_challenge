class CreateOrder
  Result = Struct.new(:success?, :order, :errors)

  def initialize(user:, total:)
    @user = user
    @total = total.to_i
  end

  def call
    order = @user.orders.build(total: @total)
    if order.valid?
      order.save!
      SolidQueue.enqueue(SomeJob, order.id)
      Result.new(true, order, nil)
    else
      Result.new(false, nil, order.errors.full_messages)
    end
  rescue => e
    Result.new(false, nil, [e.message])
  end
end
