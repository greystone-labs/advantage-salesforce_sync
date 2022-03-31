# frozen_string_literal: true

require_relative "salesforce_sync/version"
require_relative "salesforce_sync/client"
require_relative "salesforce_sync/base"
require 'restforce'
require 'active_support/all'


require_relative "salesforce_sync/opportunity_contact"
require_relative "salesforce_sync/opportunity_team_member"

module Advantage
  module SalesforceSync
    class Error < StandardError; end


  end
end

__END__


client = Restforce.new(host: 'test.salesforce.com')
response = client.authenticate!
# => #<Restforce::Mash access_token="..." id="https://login.salesforce.com/id/00DE0000000cOGcMAM/005E0000001eM4LIAU" instance_url="https://na9.salesforce.com" issued_at="1348465359751" scope="api refresh_token" signature="3fW0pC/TEY2cjK5FCBFOZdjRtCfAuEbK1U74H/eF+Ho=">

# Get the user information
info = client.get(response.id).body
info.user_id

client = Restforce.new(host: 'test.salesforce.com',
                        username: ENV.fetch("SALESFORCE_USERNAME"),
                        password: ENV.fetch("SALESFORCE_PASSWORD"),
                        client_id: ENV.fetch("SALESFORCE_CONSUMER_KEY"),
                        client_secret: ENV.fetch("SALESFORCE_CONSUMER_SECRET"),
                        security_token: ENV.fetch("SALESFORCE_SECURITY_TOKEN")
                        )



accounts = client.query("select Id, Something__c from Account where Id = 'someid'")
client.find('Account', '001D000000INjVe')

client.user_info
limits = client.limits

# Get the global describe for all sobjects
client.describe

describe and check that the mappings are consistent
client.list_sobjects
client.describe('Opportunity')
# client.describe('Account')
client.describe('Opportunity_Contact__c')
client.describe('Opportunity_Property__c')

client.describe('property__c')
client.describe('User')
client.describe('Contact')
client.describe('opportunityteammember')


updated =  client.get_updated('Opportunity', (Time.now-1.day), Time.now)
updated.fetch('ids').each do | update_id | 
  # client.query("select Id, name from Opportunity where Id = '#{update_id}'")
  opty = client.find('Opportunity', update_id)

  fields = client.describe('Opportunity_Contact__c')['fields'].pluck("name")
  splat = fields.join(', ')
   
  # get collection -> https://rubydoc.info/gems/restforce/Restforce/Collection
  op_cons = client.query_all("select #{splat} from Opportunity_Contact__c where opportunity__c = '#{ opty['Id']}'")

  op_cons.each do |op_con| 
    # Contact__c
    conid = op_con.fetch("Contact__c")
    op_con.fetch("Opportunity__c")

    contact = client.find('Contact', conid)
  end


  fields = client.describe('opportunityteammember')['fields'].pluck("name")
  splat = fields.join(', ')
   
  op_team = client.query_all("select #{splat} from opportunityteammember where OpportunityId = '#{ opty['Id']}'")


end
