# frozen_string_literal: true

RSpec.describe Advantage::SalesforceSync::Base do
  include_context 'authentication'

  # let(:client)  { Advantage::SalesforceSync::Client.new }
  let(:client) { instance_double("Advantage::SalesforceSync::Client") }
  let(:base) { Advantage::SalesforceSync::Base.new(client: client, id: sf_id) }
  let(:table_name) { "Opportunity_Contact__c" }
  let(:sf_id) { nil }
  let(:relation) { { user: { "Id" => "00579000000quzoAAA", "Username" => "john.someone@mailinator.com" } } }
  let(:fields) do
    [
      { "name" => "Id" },
      { "name" => "Name" }
    ]
  end

  before do
    authenticate!
    stub_const("TABLE_NAME", table_name)
    stub_const("MAPPINGS", { opportunity_id: "Opportunity__c", contact_id: "Contact__c" })
    allow(client).to receive("connection")
  end

  it "initializes" do
    expect(base).not_to be nil
  end

  describe "splat" do
    before do
      allow_any_instance_of(Restforce::Client).to receive(:describe).with(table_name).and_return({ "fields" => fields })
    end

    it "converts splat(*) to values" do
      # allow(client.connection).to receive("describe").and_return({ "fields" => fields })
      expect(described_class.splat).to eq("Id, Name")
    end
  end

  xit "transforms relationship struct to mapped" do
    mapped = { user: { id: "00579000000quzoAAA" } }
    expect(base.transform(relation)).to eq mapped
  end

  describe "get_relationships" do
    context "when id is nil" do
      it { expect(base.get_relationships).to be_nil }
    end
  end
end
