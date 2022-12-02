# Advantage::SalesforceSync

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/advantage/salesforce_sync`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Set up

You must set up a oauth connected app in salesforce and configure a user to be able to log in and use this service
 * create new app
setup -> apps -> app manager 
"new connected app"
enable oauth
copy the oauth keys/secret


### User Credential Setup
* if using a service account

https://glabs--stage.lightning.force.com/lightning/setup/ManageUsers/

click 'login'

* set password
https://glabs--stage.lightning.force.com/lightning/settings/personal/ChangePassword/home

* set up an access/security token for the user
get security token
https://glabs--stage.lightning.force.com/lightning/settings/personal/ResetApiToken/home

**important** each time you change password security token gets changed.

* enable scope for user or set/allow ip restriptions
allow user and ip restrictions 
setup -> apps -> connected -> 'edit'


## Configure
 some of the terminalogy is different between salesforce and oauth https://help.salesforce.com/s/articleView?id=sf.remoteaccess_terminology.htm&type=5
for instance client_id = consumer_key, consumer_secret = client_secret

export SALESFORCE_HOST='test.salesforce.com' # or "login.salesforce.com"
export SALESFORCE_USERNAME=""
export SALESFORCE_PASSWORD=''
export SALESFORCE_SECURITY_TOKEN=""
export SALESFORCE_CLIENT_ID=""
export SALESFORCE_CLIENT_SECRET=""
export SALESFORCE_API_VERSION="41.0"

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'advantage-salesforce_sync'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install advantage-salesforce_sync

## Usage
Use with your own models outside of the gem

```ruby
module MyModule
  class Custom < Advantage::SalesforceSync::Base
    attr_accessor :id, :name, :custom_field

    TABLE_NAME = "Custom_Table"
    RELATIONSHIPS = {
      property: {
        class: Property,
        through: CustomProperty,
        through_key: "Opportunity__c",
        foreign_key: :custom_id
      }
    }.freeze

    MAPPINGS = {
      id: "Id",
      name: "Name",
      description: "Description",
      custom_field: "Customfield__c"
    }.freeze
end

```


Find records

```ruby
Advantage::SalesforceSync::Models::Opportunity.find(opportunity_id) # returns single record
Advantage::SalesforceSync::Models::Opportunity.new.updated(from: (Time.now - 1.day), to: Time.now) # returns a map of id's updated in the last day

```

Find fields to map

```ruby

client = Restforce.new(host: ENV.fetch("SALESFORCE_HOST"))

# -- OR --
op = Advantage::SalesforceSync::Models::Opportunity.new

fields = client.describe('Opportunity')['fields'].pluck("name")

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/advantage-salesforce_sync.
