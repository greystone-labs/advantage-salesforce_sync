RSpec.describe OpportunityContact do
  let(:sf_id) { "a0a79000000fUlHAAU" }
  let(:opportunity_id) { "00679000005i9CAAAY" }
  let(:contact_id) { "00379000006ke5vAAA" }
  let(:opportunity_contact) { described_class.new(id: sf_id) }
  let(:contact_attrs) do
    {
      id: "00379000006ke5vAAA",
      email: "brendan.dunbar@cushwake.com",
      first_name: "Brendan",
      last_name: "Dunbar",
      phone_number: nil
    }
  end
  let(:s_object) do
    Restforce::SObject.new({
      "Id" => "00379000006ke5vAAA",
      "Email" => "brendan.dunbar@cushwake.com",
      "FirstName" => "Brendan",
      "LastName" => "Dunbar",
      "Phone" =>nil
    })
  end

  describe "#contact" do
    before do
      opportunity_contact.instance_variable_set("@opportunity_id", opportunity_id)
      opportunity_contact.instance_variable_set("@contact_id", contact_id)

      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(Contact::TABLE_NAME, opportunity_contact.contact_id)
        .and_return(s_object)
    end

    it "calls find on Contact class" do
      expect(Contact).to receive(:find).once.and_call_original
      opportunity_contact.contact
    end

    it "returns instance of Contact class" do
      expect(opportunity_contact.contact).to be_a Contact
    end

    it "returns Contact with correct attributes" do
      expect(opportunity_contact.contact.attributes).to include(contact_attrs)
    end
  end
end
