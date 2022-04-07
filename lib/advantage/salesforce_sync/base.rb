require "pry"
module Advantage
  module SalesforceSync
    class Base
      # attr_accessor :attributes
      attr_reader :client, :table_name, :id

      def initialize(client: nil, id: nil)
        # @client = client.connection
        @client = (client || Client.send(:new)).connection
        @id = id
      end

      def table_name
        self.class.const_get(:TABLE_NAME)
      end

      def attributes
        self.class.const_get(:MAPPINGS).each_with_object({}) do |(key, _value), hash|
          hash[key] = instance_variable_get("@#{key}")
        end
      end

      def find(id)
        rec = client.find(table_name, id)
        fields = self.class.const_get(:MAPPINGS).values
        attrs = rec.attrs.slice(*fields)
        self.class.const_get(:MAPPINGS).each do |key, field|
          instance_variable_set("@#{key}", attrs[field])
        end
        # attributes = rec.attrs.slice(*fields)
      end

      class << self
        def table_name
          const_get(:TABLE_NAME)
        end

        def find(id)
          return nil unless id

          klass = new
          rec = klass.client.find(table_name, id)
          fields = const_get(:MAPPINGS).values
          # klass.attributes = rec.attrs.slice(*fields)
          attrs = rec.attrs.slice(*fields)

          const_get(:MAPPINGS).each do |key, field|
            klass.instance_variable_set("@#{key}", attrs[field])
          end

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
            # klass.attributes = result.attrs
            fields = const_get(:MAPPINGS).values
            # klass.attributes = rec.attrs.slice(*fields)
            attrs = result.attrs.slice(*fields)

            const_get(:MAPPINGS).each do |key, field|
              klass.instance_variable_set("@#{key}", attrs[field])
            end
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

      def get_relationships
        return nil unless id

        self.class.const_get(:RELATIONSHIPS).each_with_object({}) do |(key, rel), hash|
          hash[key] = if rel[:through]
                        get_through_relationships(rel)
                      else
                        get_has_one_relationship(rel)
                      end
        end
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

      private

      def get_has_one_relationship(rel)
        rel[:class].find(attributes[rel[:foreign_key]])
      end

      def get_through_relationships(rel)
        through_resources = rel[:through].where(foreign_key: rel[:through_key], foreign_key_id: id)
        through_resources.map do |resource|
          rel[:class].find(resource.attributes[rel[:foreign_key]])
        end
      end
    end
  end
end
