require 'json'
require_relative 'car'
require_relative 'price'
require_relative 'rental'

class JsonResponse
  attr_accessor :json_input

  def initialize(json_input:)
    @json_input = JSON.parse(open(json_input).read)
  end 

  def prices_generator
    hash_cars = {}
    @json_input.dig('cars').map do |car_informations|
      hash_cars[car_informations['id']] = car_informations
    end 

    rentals = @json_input.dig('rentals').map do |rental_informations|
      Rental.new(informations: rental_informations)
    end 
   
    prices = rentals.map do |rental|
      Price.new(rental: rental, car: Car.new(informations: hash_cars[rental.car_id]))  
    end 

    final_prices = {}
    arr_rentals = []
    prices.each do |price|
      arr_rentals << { "id": price.rental_id, "price": price.rental_price, 
        "commission": {
          "insurance_fee": price.insurance_fee, 
          "assistance_fee": price.assistance_fee, 
          "drivy_fee": price.drivy_fee }
        }
    end 
    final_prices["rentals"] = arr_rentals
    final_prices
  end 
end 