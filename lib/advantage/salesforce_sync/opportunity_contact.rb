# frozen_string_literal: true

class OpportunityContact < Advantage::SalesforceSync::Base
  TABLE_NAME = "Opportunity_Contact__c"
  attr_accessor :opportunity_id, :contact_id

  MAPPINGS = {
    id: "Id",
    opportunity_id: "Opportunity__c",
    contact_id: "Contact__c"
  }

  RELATIONSHIPS = { contact: { class: Contact, foreign_key: :contact_id } }

  def contact
    return @contact if @contact

    @contact = get_relationships[:contact]
  end
end

__END__


# opportunity.updated
# team_member.updated
# opportunity_contact.updated

# contact.updated ( deletes / email udpates for contacts )
