RSpec.describe Advantage::SalesforceSync::Models::OpportunityContact do
  include_context "authentication"

  let(:sf_id) { "a0a79000000fUlHAAU" }
  let(:opportunity_id) { "00679000005i9CAAAY" }
  let(:contact_id) { "00379000006ke5vAAA" }
  let(:opportunity_contact) { described_class.new(id: sf_id) }
  let(:relationships) { Advantage::SalesforceSync::Models::OpportunityContact::RELATIONSHIPS }
  let(:role) { "Borrower - Key Principle" }
  let(:opportunity_contact_attrs) do
    {
      id: sf_id,
      opportunity_id: opportunity_id,
      contact_id: contact_attrs[:id],
      role: role
    }
  end

  let(:contact_attrs) do
    {
      id: "00379000006ke5vAAA",
      email: "brendan.dunbar@cushwake.com",
      first_name: "Brendan",
      last_name: "Dunbar",
      phone_number: nil
    }
  end

  let(:sopcontact_object) do
    Restforce::SObject.new({
                             "Id" => sf_id,
                             "Role__c" => role,
                             "Contact__c" => contact_id,
                             "Opportunity__c" => opportunity_id
                           })
  end

  let(:scontact_object) do
    Restforce::SObject.new({
                             "Id" => "00379000006ke5vAAA",
                             "Email" => "brendan.dunbar@cushwake.com",
                             "FirstName" => "Brendan",
                             "LastName" => "Dunbar",
                             "Phone" => nil
                           })
  end

  before do
    authenticate!
  end

  describe "opportunity_contact" do
    let(:opportunity_contact) { described_class.find(sf_id) }
    before do
      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(described_class::TABLE_NAME, sf_id)
        .and_return(sopcontact_object)
    end

    it "returns opportunity_contact with correct attributes" do
      expect(opportunity_contact.attributes).to include(opportunity_contact_attrs)
    end

    it { expect(opportunity_contact.role).to eq(role) }
  end

  describe "#contact" do
    before do
      opportunity_contact.instance_variable_set("@opportunity_id", opportunity_id)
      opportunity_contact.instance_variable_set("@contact_id", contact_id)

      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(relationships[:contact][:class]::TABLE_NAME, opportunity_contact.contact_id)
        .and_return(scontact_object)
    end

    it "calls find on Contact class" do
      expect(relationships[:contact][:class]).to receive(:find).once.and_call_original
      opportunity_contact.contact
    end

    it "returns instance of Contact class" do
      expect(opportunity_contact.contact).to be_a Advantage::SalesforceSync::Models::Contact
    end

    it "returns Contact with correct attributes" do
      expect(opportunity_contact.contact.attributes).to include(contact_attrs)
    end
  end
end
