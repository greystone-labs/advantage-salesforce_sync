RSpec.describe Opportunity do
  let(:sf_id) { "00679000005i9CAAAY" }
  let(:opportunity) { described_class.new(id: sf_id) }
  let(:property_attrs) do
    { "Id" => "a0Z79000000IO6rEAG",
      "Name" => "name",
      "Street__c" => "123 street",
      "Zip_Code__c" => "63021",
      "State__c" => "Illinois",
      "City__c" => "Alsip" }
  end
  it "fetches property" do
    expect(Property).to receive(:find).once.and_call_original
    expect(opportunity.property).to be_a Property
    expect(opportunity.property.attributes).to include(property_attrs)
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
