# frozen_string_literal: true

RSpec.describe Advantage::SalesforceSync::Base do
  include_context "authentication"

  let(:base) { Advantage::SalesforceSync::Base.new(id: sf_id) }
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

  describe "#where" do
    context "when not found" do
      before {
        allow_any_instance_of(Restforce::Client).to receive(:query_all).and_return([])
        allow_any_instance_of(Restforce::Client).to receive(:describe).and_return({'fields' => [{'name' => 'id'}]})
      }
      it { expect(described_class.where(foreign_key: 'not_a_key', foreign_key_id: 12321)).to be_empty }
    end
  end
end
