# frozen_string_literal: true

require "pry"
# require_relative "opportunity_property"
# require_relative "property"

class Opportunity < Advantage::SalesforceSync::Base
  attr_accessor :id, :name, :description, :closing_date, :closed_date, :stage, :status, :loan_type, :start_date

  TABLE_NAME = "Opportunity"
  RELATIONSHIPS = {
    property: {
      class: Property,
      through: OpportunityProperty,
      through_key: "Opportunity__c",
      foreign_key: :property_id
    }
  }

  MAPPINGS = {
    id: "Id",
    name: "Name",
    description: "Description",
    closing_date: "Closing_Date__c",
    closed_date: "CloseDate",
    stage: "StageName",
    status: "Status__c",
    loan_type: "Loan_Type__c",
    start_date: "Kick_Off_Date__c"
  }

  def property
    return @property if @property

    properties = get_relationships[:property]
    raise Error, "More than one property returned" if properties.count > 1

    @property = properties.first
  end
end

__END__

op = Opportunity.find("00679000005i9CAAAY")


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
