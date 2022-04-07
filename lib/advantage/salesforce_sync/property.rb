# frozen_string_literal: true

class Property < Advantage::SalesforceSync::Base
  attr_accessor :name, :zip_code, :city, :street_address, :property_type, :longitude, :latitude, :state

  TABLE_NAME = "Property__c"

  MAPPINGS =
    {
      id: "Id",
      name: "Name",
      zip_code: "Zip_Code__c",
      city: "City__c",
      street_address: "Street__c",
      property_type: "Property_Type__c",
      longitude: "Longitude__c",
      latitude: "Latitude__c",
      state: "State__c"
    }.freeze
  # lookup through opportunity_property__c
end
