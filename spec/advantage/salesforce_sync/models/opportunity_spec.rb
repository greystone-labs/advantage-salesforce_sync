RSpec.describe Advantage::SalesforceSync::Models::Opportunity do
  include_context "authentication"

  let(:sf_id) { "00679000005i9CAAAY" }
  let(:opportunity) { described_class.new(id: sf_id) }
  let(:relationships) { Advantage::SalesforceSync::Models::Opportunity::RELATIONSHIPS }
  let(:property_attrs) do
    {
      city: "Alsip",
      id: "a0Z79000000IO6rEAG",
      latitude: nil,
      longitude: nil,
      name: "name",
      property_type: "Multifamily",
      state: "Illinois",
      street_address: "123 street",
      zip_code: "63021"
    }
  end

  let(:so_op_property) do
    Restforce::SObject.new({
                             "Opportunity__c" => "00679000005i9CAAAY",
                             "Property__c" => "a0Z79000000IO6rEAG"
                           })
  end

  let(:so_property) do
    Restforce::SObject.new({
                             "Id" => "a0Z79000000IO6rEAG",
                             "Name" => "name",
                             "Zip_Code__c" => "63021",
                             "City__c" => "Alsip",
                             "Street__c" => "123 street",
                             "Property_Type__c" => "Multifamily",
                             "Longitude__c" => nil,
                             "Latitude__c" => nil,
                             "State__c" => "Illinois"
                           })
  end

  before do
    authenticate!
  end

  describe "#mapped" do
    before do
      allow_any_instance_of(Restforce::Client).to receive(:find).and_return(Restforce::SObject.new({ "Loan_Platform__c" => "mocked" }))
    end

    subject { described_class.find(sf_id) }
    it { expect(subject.platform).to eq("mocked") }
  end

  describe "#properties" do
    before do
      allow_any_instance_of(Restforce::Client).to receive(:query_all).and_return([so_op_property])
      allow_any_instance_of(Restforce::Client).to receive(:describe).and_return({ "fields" => {} })

      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(relationships[:property][:class]::TABLE_NAME, so_op_property.attrs["Property__c"])
        .and_return(so_property)
    end

    it "calls find on Property class" do
      expect(Advantage::SalesforceSync::Models::Property).to receive(:find).once.and_call_original
      opportunity.properties
    end

    it "calls where on OpportunityProperty" do
      expect(Advantage::SalesforceSync::Models::OpportunityProperty).to receive(:where).once.with(foreign_key: relationships[:property][:through_key],
                                                                                                  foreign_key_id: sf_id).and_call_original
      opportunity.properties
    end

    it "returns array of Property classes" do
      expect(opportunity.properties.map(&:class)).to match_array([Advantage::SalesforceSync::Models::Property])
    end

    it "returns Property with correct attributes" do
      expect(opportunity.properties.first.attributes).to include(property_attrs)
    end
  end
end

__END__
#<OpportunityProperty:0x00007f3779f9d050
  @attributes=
   {"Id"=>"a0b7900000144QcAAI",
    "IsDeleted"=>false,
    "Name"=>"OP-24197",
    "CreatedDate"=>"2022-04-04T16:14:29.000+0000",
    "CreatedById"=>"0053m00000BLJkhAAH",
    "LastModifiedDate"=>"2022-04-04T16:14:29.000+0000",
    "LastModifiedById"=>"0053m00000BLJkhAAH",
    "SystemModstamp"=>"2022-04-04T16:14:29.000+0000",
    "Opportunity__c"=>"00679000005i9CAAAY",
    "Property__c"=>"a0Z79000000IO6rEAG",
    "Opportunity_Name__c"=>"name",
    "Property_Name__c"=>"name",
    "VL_Temp__c"=>nil},

  {"Id"=>"a0Z79000000IO6rEAG",
   "Name"=>"name",
   "Street__c"=>"123 street",
   "Zip_Code__c"=>"63021",
   "State__c"=>"Illinois",
   "City__c"=>"Alsip"}
