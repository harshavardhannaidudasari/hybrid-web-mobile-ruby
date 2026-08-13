require 'hybrid_framework/driver_factory'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.disable_monkey_patching!
end

def create_driver_for(platform)
  HybridFramework::DriverFactory.create_driver(platform)
end
