class SampleJob < ApplicationJob
  queue_as :default

  def perform(name)
    puts "Hello #{name} from Solid Queue!"
  end
end
