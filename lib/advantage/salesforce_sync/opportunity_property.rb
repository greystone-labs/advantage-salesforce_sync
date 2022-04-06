# frozen_string_literal: true

class OpportunityProperty < Advantage::SalesforceSync::Base
  attr_accessor :id, :opportunity_id, :property_id

  TABLE_NAME = "Opportunity_Property__c"
  # RELATIONSHIPS = {
  #   property: {
  #     class: Property,
  #     foreign_key: :property_id
  #   },
  #   opportunity: {
  #     class: Opportunity,
  #     foreign_key: :opportunity_id
  #   }
  # }

  MAPPINGS =
    {
      id: 'Id',
      opportunity_id: 'Opportunity__c',
      property_id: 'Property__c'
    }.freeze
end