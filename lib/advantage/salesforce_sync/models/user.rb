# frozen_string_literal: true
module Advantage
  module SalesforceSync
    class Models
      class User < Advantage::SalesforceSync::Base
        attr_accessor :email, :first_name, :last_name, :phone_number

        TABLE_NAME = "user"

        MAPPINGS =
          {
            id: "Id",
            email: "Email",
            first_name: "FirstName",
            last_name: "LastName",
            phone_number: "Phone"
          }.freeze
      end
    end
  end
end
