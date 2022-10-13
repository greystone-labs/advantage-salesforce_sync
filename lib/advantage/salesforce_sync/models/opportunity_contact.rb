# frozen_string_literal: true

module Advantage
  module SalesforceSync
    class Models
      class OpportunityContact < Advantage::SalesforceSync::Base
        TABLE_NAME = "Opportunity_Contact__c"
        attr_accessor :opportunity_id, :contact_id, :role

        MAPPINGS = {
          id: "Id",
          opportunity_id: "Opportunity__c",
          contact_id: "Contact__c",
          role: "Role__c"
        }.freeze

        RELATIONSHIPS = { contact: { class: Contact, foreign_key: :contact_id } }

        def contact
          return @contact if @contact

          @contact = get_relationships[:contact]
        end
      end
    end
  end
end
