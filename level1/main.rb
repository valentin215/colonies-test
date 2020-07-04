require 'json'
require_relative '../lib/json_response'

response = JsonResponse.new(json_input: "../level1/data/input.json")
@hash_prices = response.prices_generator.to_json
puts @hash_prices
