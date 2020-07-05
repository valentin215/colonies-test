require 'json'
require_relative '../lib/json_response'
require '../spec/spec_helper'

RSpec.describe 'JsonResponse' do 
  it 'returns expected json output' do
    json_response = JsonResponse.new(json_input: '../level4/data/input.json')
    json_expected = JSON.parse(open('../level4/data/expected_output.json').read)
    expect(json_response.prices_generator.to_json).to eq(json_expected.to_json)
  end
end 