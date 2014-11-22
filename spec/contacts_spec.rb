require 'spec_helper'
require 'json_spec'
require 'pry'
require 'awesome_print'

describe Onepagecrm do
  subject { Onepagecrm.new(TEST_CONFIG['login'], TEST_CONFIG['password']) }

  describe '#contact' do
    it 'creates, gets, updates and deletes a contact' do

      contacts = subject.get('contacts.json')
      ap contacts
      expect(contacts['status']).to eq 0
      new_contact_details = ({
        'first_name' => 'yes',
        'last_name' => 'address',
        'company_name' => 'ACME&inc',
        'starred' => false,
        'tags' => %w(api_test1 api_test2),
        'emails' => [{
          'type' => 'work',
          'value' => 'johnny@exammmple.com' }],
        'phones' => [{
          'type' => 'work',
          'value' => '00033353' }],
        'urls' => [{
          'type' => 'website',
          'value' => 'lsdkiteboarding.com' }],
        'background' => 'BACKGROUND',
        'job_title' => 'JOBTITLE',
        'address_list' => [
          'city' => 'San Francisco',
          'state' => 'CA'
        ]
      })
      puts subject.post('contacts.json', new_contact_details)
      new_contact = subject.post('contacts.json', new_contact_details)['data']
      new_contact_id = new_contact['contact']['id']
      got_deets = subject.get("contacts/#{new_contact_id}.json?search=yes")['data']['contact']
      expect(got_deets['first_name']).to eq(new_contact_details['first_name'])

      details_without_address = new_contact_details.reject { |k| k == 'address_list' }

      details_without_address.each do |k, _v|
        expect(got_deets[k]).to eq(new_contact_details[k])
      end

      # check address
      address = got_deets['address_list'][0]
      expect(address['city']).to eq 'San Francisco'
      expect(address['state']).to eq 'CA'

      subject.put("contacts/#{new_contact_id}.json", { 'partial' => true,
                                                       'first_name' => 'Pat' })
      got_deets = subject.get("contacts/#{new_contact_id}.json")['data']['contact']
      expect(got_deets['first_name']).to eq 'Pat'

      # delete contact
      subject.delete("contacts/#{new_contact_id}.json")
    end
  end

end
