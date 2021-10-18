# OnePageCRM

This gem is a basic wrapper around the OnePageCRM API. 
It does not abstract all API calls to ruby methods on the gem object but simply gives the `GET`, `POST`, `PUT` and `DELETE` methods.
The gem handles all the authentication with the OnePageCRM API.

## Installation

Add this line to your application's Gemfile:

    gem 'onepagecrm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install onepagecrm

## Usage
You can try out the OnePageCRM gem in an interactive ruby session
    
    $ irb
    irb:> require 'onepagecrm'
    irb:> api_client = OnePageCRM.new('user_id', 'api_key')
    irb:> api_client.get('contacts.json')
    irb:> api_client.post('contacts.json', {'last_name': 'Bravo', 'first_name': 'Johnny'} )

Take a look at the [OnePageCRM Developer][1] site for more details on API functionality.

## Support
The best way to get support is through the [OnePageCRM Developer Forum][2]

## Contributing

We welcome any contributions.

1. Create an issue relating to the feature that you require.
2. Fork the repo ( https://github.com/[my-github-username]/onepagecrm/fork )
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

  [1]: http://developer.onepagecrm.com
  [2]: http://forum.developer.onepagecrm.com
