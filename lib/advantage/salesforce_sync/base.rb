require 'pry'
module Advantage
  module SalesforceSync
    class Base
      attr_reader :client, :table_name

      def initialize(client:)
        @client = client.connection
      end

      def table_name
        # @table_name = table_name # Opportunity_Contact__c
        self.class.const_get(:TABLE_NAME)
      end

      def find(id)
        rec = client.find(table_name, id)
        rec = rec.attrs
      end

      def where(foreign_key:, foreign_key_id:) 
        # get collection -> https://rubydoc.info/gems/restforce/Restforce/Collection
        # op_cons = client.query_all("select #{splat} from Opportunity_Contact__c where opportunity__c = '#{ opty['Id']}'")
        client.query_all("select #{splat} from #{table_name} where #{foreign_key} = '#{ foreign_key_id }'")     
      end

      # => {"ids"=>["a0a79000000exLEAAY"], "latestDateCovered"=>"2022-03-29T19:02:00.000+0000"} 
      # => ["a0a79000000exLEAAY"] 
      def updated(from: (Time.now-1.day), to: Time.now)
        client.get_updated(table_name, from, to).dig('ids')
      end
      
      def splat
        fields = client.describe(table_name)['fields'].pluck("name")
        splat = fields.join(', ')
      end

      def relationships(id)
        result = find(id)
        rels = self.class.const_get(:RELATIONSHIPS)
        # TODO: pass an object for the relationships and grab self.class.const_get(:TABLE_NAME)
        rels.each_with_object({}) do |(k,v), hsh| 
          hsh[k] = client.find(k.to_s.capitalize, result[v]).attrs
        end

        # 3.1.0 :019 > res['Contact__c']
        #  => "00379000006kaVAAAY" 
        # 3.1.0 :020 > res['Opportunity__c']
        #  => "00679000005hw1QAAQ" 
      end

      # TODO: pass some mapping that cleans the data object.. i.e. 'Id' => :id
      def transform
        mappings = MAPPINGS

        mappings.each_with_object({}) do |(k,v), hsh|
          hsh[k] =>
          rel[key]
        end
      # mapped_data = mappings.transform_values do |etl|
      #   if etl.is_a?(Hash)
      #     key = mappings.key(etl)
      #     etl.transform_values do |etl_rel|
      #       attributes[key][etl_rel]
      #     end
      #   else
      #     attributes[etl]
      #   end
      # end

      end
    end

    private
  end
end
