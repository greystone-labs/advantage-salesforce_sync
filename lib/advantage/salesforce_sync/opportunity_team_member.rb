class OpportunityTeamMember < Advantage::SalesforceSync::Base
  TABLE_NAME = 'opportunityteammember'
  # table_name: :foreign_key
  RELATIONSHIPS = { user: "UserId", opportunity: "OpportunityId" }
  MAPPINGS  = { 
    opportunity: { 'Id': :id}
  }
end

__END__
client = Advantage::SalesforceSync::Client.new
con = OpportunityTeamMember.new(client: client)
updates = con.updated(from: Time.now-10.days)
con.relationships(updates.first)

updates.each do |id| 
  con.relationships(id)
end
