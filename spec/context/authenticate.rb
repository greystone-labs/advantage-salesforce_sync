# frozen_string_literal: true

RSpec.shared_context "authentication" do
  # Mock Restforce::Client.authenticate! for testing

  class DoubleClient
    attr_accessor :client

    def connection
      Restforce::Data::Client.new
    end
  end

  let(:client_double) { double(Advantage::SalesforceSync::Client) }

  def authenticate!
    stub_const("Advantage::SalesforceSync::Client", client_double)
    allow(client_double).to receive(:instance).and_return(DoubleClient.new)
    allow(client_double).to receive(:connection).and_return(Restforce::Data::Client.new)
  end
end
