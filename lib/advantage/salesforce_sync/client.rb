require 'restforce'
module Advantage
  module SalesforceSync
    class Client
      attr_accessor :client

      def initialize
        self.client = Restforce.new(host: ENV.fetch('SALESFORCE_HOST'))

          # Restforce.new :username => Rails.application.secrets.salesforce_username,
          #   :password       => Rails.application.secrets.salesforce_password,
          #   :security_token => Rails.application.secrets.salesforce_security_token,
          #   :client_id      => Rails.application.secrets.salesforce_client_id,
          #   :client_secret  => Rails.application.secrets.salesforce_client_secret,
          #   :host           => Rails.application.secrets.salesforce_host,
          #   :debugging      => Rails.application.secrets.salesforce_debugging
        client.authenticate!
      end

      def connection
        @connection ||= self.client
      end
    end
  end
end