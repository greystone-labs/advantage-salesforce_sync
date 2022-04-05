require "pry"
module Advantage
  module SalesforceSync
    class Base
      attr_accessor :attributes
      attr_reader :client, :table_name, :id

      def initialize(client: nil, id: nil)
        # @client = client.connection
        @client = (client || Client.send(:new)).connection
        @id = id
      end

      def table_name
        self.class.const_get(:TABLE_NAME)
      end

      def find(id)
        rec = client.find(table_name, id)
        attributes = rec.attrs
      end

      class << self
        def table_name
          const_get(:TABLE_NAME)
        end

        def find(id)
          klass = new
          rec = klass.client.find(table_name, id)
          klass.attributes = rec.attrs
          klass
        end

        def find_by(key:, id:)
          klass = new
          rec = klass.client.find(table_name, id, key)
          rec = rec.attrs
          klass
        end

        def where(foreign_key:, foreign_key_id:)
          klass = new

          # get collection -> https://rubydoc.info/gems/restforce/Restforce/Collection
          # op_cons = client.query_all("select #{splat} from Opportunity_Contact__c where opportunity__c = '#{ opty['Id']}'")
          all = klass.client.query_all("select #{splat} from #{table_name} where #{foreign_key} = '#{foreign_key_id}'")

          # all.map(&:attrs)
          all.map do |result|
            klass = klass.dup
            klass.attributes = result.attrs
            klass
          end
        end

        def splat
          klass = new
          fields = klass.client.describe(table_name)["fields"].pluck("name")
          splat = fields.join(", ")
        end
        end

      # => {"ids"=>["a0a79000000exLEAAY"], "latestDateCovered"=>"2022-03-29T19:02:00.000+0000"}
      # => ["a0a79000000exLEAAY"]
      def updated(from: (Time.now - 1.day), to: Time.now)
        client.get_updated(table_name, from, to).dig("ids")
      end

      def relationships(id)
        result = find(id)
        rels = self.class.const_get(:RELATIONSHIPS)
        # TODO: pass an object for the relationships and grab self.class.const_get(:TABLE_NAME)
        rels.each_with_object({}) do |(k, v), hsh|
          hsh[k] = client.find(k.to_s.capitalize, result[v]).attrs
        end
        # > res['Contact__c']
        #  => "00379000006kaVAAAY"
        # res['Opportunity__c']
        #  => "00679000005hw1QAAQ"
      end

      # TODO: pass some mapping that cleans the data object.. i.e. 'Id' => :id
      def transform(relationship)
        mappings = MAPPINGS
        # mappings = {:user=>{"Id"=>:id}}
        # relationship = {:user=>{"Id"=>"00579000000quzoAAA", "Username"=>"john.someone@mailinator.com"}}
        mappings.each_with_object({}) do |(k, _v), hsh|
          hsh[k] = mappings[k].each_with_object({}) do |(kk, vv), nhsh|
            nhsh[vv] = relationship[k][kk]
          end
        end
      end
    end
  end
end
