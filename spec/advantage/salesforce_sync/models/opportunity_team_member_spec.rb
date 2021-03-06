RSpec.describe Advantage::SalesforceSync::Models::OpportunityTeamMember do
  include_context "authentication"

  let(:sf_id) { "00q79000000KapBAAS" }
  let(:opportunity_id) { "00679000005i5igAAA" }
  let(:user_id) { "0051N00000602RtQAI" }

  let(:opportunity_team_member) { described_class.new(id: sf_id) }
  let(:relationships) { Advantage::SalesforceSync::Models::OpportunityTeamMember::RELATIONSHIPS }
  let(:role) { "Greystone - Project Manager" }

  let(:opportunity_team_member_attrs) do
    {
      id: sf_id,
      opportunity_id: opportunity_id,
      user_id: user_id,
      role: role
    }
  end

  let(:user_attrs) do
    {
      email: "field.springer@greyco.com.invalid",
      first_name: "Field",
      id: "0051N00000602RtQAI",
      last_name: "Springer",
      phone_number: "(540) 359-7054"
    }
  end

  let(:so_team_member) do
    Restforce::SObject.new({
                             "Id" => sf_id,
                             "TeamMemberRole" => role,
                             "UserId" => user_id,
                             "OpportunityId" => opportunity_id
                           })
  end

  let(:so_user) do
    Restforce::SObject.new({
                             "Id" => "0051N00000602RtQAI",
                             "Email" => "field.springer@greyco.com.invalid",
                             "FirstName" => "Field",
                             "LastName" => "Springer",
                             "Phone" => "(540) 359-7054"
                           })
  end

  let(:so_opportunity) do
    {}
  end

  before do
    authenticate!
  end

  describe "OpportunityTeamMember" do
    let(:opportunity_team_member) { described_class.find(sf_id) }
    before do
      allow_any_instance_of(Restforce::Client).to receive(:find)
        .with(described_class::TABLE_NAME, sf_id)
        .and_return(so_team_member)
    end

    it "returns opportunity_team_member with correct attributes" do
      expect(opportunity_team_member.attributes).to include(opportunity_team_member_attrs)
    end

    it { expect(opportunity_team_member.role).to eq(role) }
  end

  describe "#user" do
    before do
      authenticate!
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
      expect(Advantage::SalesforceSync::Models::User).to receive(:find).once.and_call_original
      opportunity_team_member.user
    end

    it "returns instance of User class" do
      expect(opportunity_team_member.user).to be_a Advantage::SalesforceSync::Models::User
    end

    it "returns User with correct attributes" do
      expect(opportunity_team_member.user.attributes).to include(user_attrs)
    end
  end
end
