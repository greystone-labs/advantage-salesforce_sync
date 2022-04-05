require "pry"
class Opportunity < Advantage::SalesforceSync::Base
  attr_accessor :id

  TABLE_NAME = "Opportunity"
  RELATIONSHIPS = {}

  def property
    # op = find(id)
    return @property if @property

    opportunity_property = OpportunityProperty.where(foreign_key: "Opportunity__c", foreign_key_id: id)
    raise Error, "More than one property returned" if opportunity_property.count > 1

    opportunity_property = opportunity_property.first
    @property = opportunity_property.property
  end
end

class OpportunityProperty < Advantage::SalesforceSync::Base
  TABLE_NAME = "Opportunity_Property__c"
  RELATIONSHIPS = { property__c: "Property__c" }

  def property
    # TODO: should we memoize?
    @property ||= Property.find(attributes["Property__c"])
  end
end

class Property < Advantage::SalesforceSync::Base
  TABLE_NAME = "Property__c"
  # lookup through opportunity_property__c
end

__END__
# client = Advantage::SalesforceSync::Client.new

con = Opportunity.new(client: client)
updates = con.updated

op = con.property(updates.first)



op = con.find(updates.first)
# find op property based off opp id
opprop = OpportunityProperty.new(client: client)
# rel = prop.find_by(key: 'opportunity__c', id: op['Id']) 
rel = opprop.where(foreign_key: 'opportunity__c', foreign_key_id: op['Id']) 

raise Error.new('More than one property returned') if rel.count > 1
property_c = rel.first.attrs

prop = Property.new(client: client)

property = prop.find(property_c)
