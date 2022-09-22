# frozen_string_literal: true

module Advantage
  module SalesforceSync
    class Models
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
        }.freeze

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
        }.freeze

        def properties
          return @properties ||= get_relationships[:property]
        end
      end
    end
  end
end
