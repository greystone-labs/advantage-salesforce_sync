class OpportunityContact < Advantage::SalesforceSync::Base
  TABLE_NAME = 'Opportunity_Contact__c'
  # table_name: :foreign_key
  RELATIONSHIPS = { contact: "Contact__c", opportunity: "Opportunity__c" }
end

__END__
client = Advantage::SalesforceSync::Client.new
con = OpportunityContact.new(client: client)
updates = con.updated

updates.each do |id| 
  con.relationships(id)
end

con.where()
