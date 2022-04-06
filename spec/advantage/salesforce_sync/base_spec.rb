# frozen_string_literal: true

RSpec.describe Advantage::SalesforceSync::Base do
  # let(:client)  { Advantage::SalesforceSync::Client.new }
  let(:client) { instance_double("Advantage::SalesforceSync::Client") }
  let(:base) { Advantage::SalesforceSync::Base.new(client: client) }
  let(:relation) { { user: { "Id" => "00579000000quzoAAA", "Username" => "john.someone@mailinator.com" } } }
  let(:fields) do
    [
      { "name" => "Id" },
      { "name" => "Name" }
    ]
  end

  before do
    stub_const("TABLE_NAME", "Opportunity_Contact__c")
    stub_const("MAPPINGS", { opportunity_id: "Opportunity__c", contact_id: 'Contact__c' })
    allow(client).to receive("connection")
  end

  it "initializes" do
    expect(base).not_to be nil
  end

  describe 'splat' do
    it "converts splat(*) to values" do
      allow(client.connection).to receive("describe").and_return({ "fields" => fields })
      expect(described_class.splat).to eq("Id, Name")
    end
  end

  it "transforms relationship struct to mapped" do
    mapped = { user: { id: "00579000000quzoAAA" } }
    expect(base.transform(relation)).to eq mapped
  end

  describe 'get_relationships' do
    let(:relationships) {{ contact: { class: Contact, foreign_key: :contact_id } }}
    before do
      stub_const("RELATIONSHIPS", relationships)
    end
    describe 'through relationship' do
      it 'calls find method on correct Class', focus: true do
        binding.pry
        expect(Contact).to receive(:find).once.and_call_original
        base.get_relationships
      end
    end
  end

end
