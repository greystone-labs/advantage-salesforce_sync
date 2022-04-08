# frozen_string_literal: true

require "advantage/salesforce_sync"
require "webmock/rspec"

WebMock.disable_net_connect!
# WebMock.allow_net_connect!

RSpec.configure do |config|

  # Mock Restforce::Client.authenticate! for testing
  config.before do
    allow_any_instance_of(Restforce::Client).to receive(:authenticate!).and_return(true)
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.filter_run_when_matching :focus
end

