RSpec.describe OpportunityTeamMember do
  let(:sf_id) { "00q79000000KapBAAS" }
  let(:opportunity_id) { "00679000005i5igAAA" }
  let(:user_id) { "0051N00000602RtQAI" }

  let(:opportunity_team_member) { described_class.new(id: sf_id) }
  let(:relationships) { OpportunityTeamMember::RELATIONSHIPS }
  let(:user_attrs) do
    {
      email: "field.springer@greyco.com.invalid",
      first_name: "Field",
      id: "0051N00000602RtQAI",
      last_name: "Springer",
      phone_number: "(540) 359-7054"
    }
  end

  let(:so_user) do
    Restforce::SObject.new({
      "Id" => "0051N00000602RtQAI",
      "Email" => "field.springer@greyco.com.invalid",
      "FirstName" =>  "Field",
      "LastName" => "Springer",
      "Phone" => "(540) 359-7054"
    })
  end

  let(:so_opportunity) do
    {}
  end

  describe "#user" do
    before do
      opportunity_team_member.instance_variable_set("@opportunity_id", opportunity_id)
      opportunity_team_member.instance_variable_set("@user_id", user_id)


      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(relationships[:opportunity][:class]::TABLE_NAME, opportunity_team_member.opportunity_id)
        .and_return(Restforce::SObject.new({}))

      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(relationships[:user][:class]::TABLE_NAME, opportunity_team_member.user_id)
        .and_return(so_user)
    end

    it "calls find on User class" do
      expect(User).to receive(:find).once.and_call_original
      opportunity_team_member.user
    end

    it "returns instance of User class" do
      expect(opportunity_team_member.user).to be_a User
    end

    it "returns User with correct attributes" do
      expect(opportunity_team_member.user.attributes).to include(user_attrs)
    end
  end
end
