# frozen_string_literal: true

RSpec.shared_context "authentication" do
  # Mock Restforce::Client.authenticate! for testing
  def authenticate!
    allow_any_instance_of(Restforce::Client).to receive(:authenticate!).and_return(true)
  end
end
