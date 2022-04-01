# frozen_string_literal: true

RSpec.describe Advantage::SalesforceSync::Base do
  # let(:client)  { Advantage::SalesforceSync::Client.new }
  let(:client) { instance_double('Advantage::SalesforceSync::Client') }
  let(:base) { Advantage::SalesforceSync::Base.new(client: client) }
  let(:relation) { { user: {"Id"=>"00579000000quzoAAA", "Username"=>"john.someone@mailinator.com"} } }
  let(:fields) { [
      { "name" => 'Id' },
      { "name" => 'Name' },
    ]
  }
  before do
    stub_const('TABLE_NAME', 'Opportunity_Contact__c')
    stub_const('MAPPINGS', { user: { 'Id' => :id } })

    stub_const('RELATIONSHIPS',  {contact: "Contact__c", opportunity: "Opportunity__c" })

    allow(client).to receive('connection')
  end
  
  it "initializes" do
    expect(base).not_to be nil
  end

  it "converts splat(*) to values" do 
    allow(client.connection).to receive('describe').and_return({'fields' => fields})
    expect(base.splat).to eq('Id, Name') 
  end

  it 'transforms relationship struct to mapped' do 
    mapped = { user: { id: "00579000000quzoAAA" } }
    expect(base.transform(relation)).to eq mapped
  end
end
