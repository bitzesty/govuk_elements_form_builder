require 'rails_helper'
require 'spec_helper'

class TestHelper < ActionView::Base; end

RSpec.describe GovukElementsFormBuilder::FormBuilder do

  it "should have a version" do
    expect(GovukElementsFormBuilder::VERSION).to eq("0.0.1")
  end

  let(:helper) { TestHelper.new }
  let(:resource)  { Person.new }
  let(:builder) { described_class.new :person, resource, helper, {} }

  describe '#text_field' do
    it 'outputs correct markup' do
      output = builder.text_field :name
      expect(output).to eq '<div class="form-group">' +
        '<label class="form-label" for="person_name">Full name</label>' +
        '<input class="form-control" type="text" name="person[name]" id="person_name" />' +
        '</div>'
    end
  end

  let(:error_summary_heading) { 'Message to alert the user to a problem goes here' }
  let(:error_summary_description) { 'Optional description of the errors and how to correct them' }

  describe '#error_summary when object has validation errors' do
    it 'outputs error full messages' do
      resource.valid?
      output = builder.error_summary resource, error_summary_heading, error_summary_description
      expect(output.split('>').join(">\n")).to eq ('<div ' +
          'class="error-summary" role="group" aria-labelledby="error-summary-heading" tabindex="-1">' +
        '<h1 id="error-summary-heading" class="heading-medium error-summary-heading">' +
          error_summary_heading +
        '</h1>' +
        '<p>' +
          error_summary_description +
        '</p>' +
        '<ul class="error-summary-list">' +
          '<li><a href="#person_name_error">Name can&#39;t be blank</a></li>' +
        '</ul>' +
      '</div>').split('>').join(">\n")
    end
  end

  describe '#error_summary when object does not have validation errors' do
    it 'outputs nil' do
      output = builder.error_summary resource, error_summary_heading, error_summary_description
      expect(output).to eq nil
    end
  end
end
