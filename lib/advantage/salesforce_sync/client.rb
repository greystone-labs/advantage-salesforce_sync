require "singleton"
require "restforce"
module Advantage
  module SalesforceSync
    class Client
      include Singleton

      def connection
        return @connection if @connection

        client = Restforce.new(host: ENV.fetch("SALESFORCE_HOST"))

        # Restforce.new :username => Rails.application.secrets.salesforce_username,
        #   :password       => Rails.application.secrets.salesforce_password,
        #   :security_token => Rails.application.secrets.salesforce_security_token,
        #   :client_id      => Rails.application.secrets.salesforce_client_id,
        #   :client_secret  => Rails.application.secrets.salesforce_client_secret,
        #   :host           => Rails.application.secrets.salesforce_host,
        #   :debugging      => Rails.application.secrets.salesforce_debugging
        client.authenticate!
        @connection = client
      end
    end
  end
end
