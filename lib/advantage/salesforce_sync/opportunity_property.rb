# frozen_string_literal: true

class OpportunityProperty < Advantage::SalesforceSync::Base
  attr_accessor :opportunity_id, :property_id

  TABLE_NAME = "Opportunity_Property__c"
  MAPPINGS =
    {
      id: 'Id',
      opportunity_id: 'Opportunity__c',
      property_id: 'Property__c'
    }.freeze
end