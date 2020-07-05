require 'json'
require_relative '../lib/json_response.rb'

response = JsonResponse.new(json_input: "../level5/data/input.json")
@hash_prices = response.prices_generator.to_json