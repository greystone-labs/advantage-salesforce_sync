class OpportunityTeamMember < Advantage::SalesforceSync::Base
  attr_accessor :opportunity_id, :user_id

  TABLE_NAME = "opportunityteammember"

  MAPPINGS = {
    id: 'Id',
    opportunity_id: "OpportunityId",
    user_id: "UserId"
  }

  RELATIONSHIPS = {
    opportunity: {
      class: Opportunity,
      foreign_key: :opportunity_id
    },
    user: {
      class: User,
      foreign_key: :user_id
    }
  }

  def user
    return @user if @user
    users = get_relationships[:user]
    raise Error, "More than one users returned" if users.count > 1
    @user = users.first
  end
end

__END__
client = Advantage::SalesforceSync::Client.new
con = OpportunityTeamMember.new(client: client)
updates = con.updated(from: Time.now-10.days)
con.relationships(updates.first)

updates.each do |id|
  con.relationships(id)
end
