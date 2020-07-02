require 'json'
require_relative '../level1/json_response.rb'

response = JsonResponse.new(json_input: "level2/data/input.json")
@hash_prices = response.prices_generator.to_json
puts @hash_prices