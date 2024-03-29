# frozen_string_literal: true

module Advantage
  module SalesforceSync
    class Models
      class OpportunityTeamMember < Advantage::SalesforceSync::Base
        attr_accessor :opportunity_id, :user_id, :role

        TABLE_NAME = "opportunityteammember"

        MAPPINGS = {
          id: "Id",
          opportunity_id: "OpportunityId",
          user_id: "UserId",
          role: "TeamMemberRole"
        }.freeze

        RELATIONSHIPS = {
          opportunity: {
            class: Opportunity,
            foreign_key: :opportunity_id
          },
          user: {
            class: User,
            foreign_key: :user_id
          }
        }.freeze

        def user
          return @user if @user

          @user = get_relationships[:user]
        end
      end
    end
  end
end
