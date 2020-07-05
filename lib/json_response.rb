require 'json'
require_relative 'car'
require_relative 'price'
require_relative 'rental'
require_relative 'option'

class JsonResponse
  # this class takes a json as an input and help us to create the final json ouptut with all required informations
  attr_accessor :json_input
  private :json_input

  def initialize(json_input:)
    @json_input = JSON.parse(open(json_input).read)
  end 

  def prices_generator
    # first we create an hash that will help you to find the car linked to the rental
    # this way, we avoid Big O(n^2) when we call car inside the loop of rentals (see below)
    hash_cars = {}
    @json_input.dig('cars').map do |car_informations|
      hash_cars[car_informations['id']] = car_informations
    end 

    # creation of Option objects
    @json_input.dig('options').each do |option_informations|
      Option.new(informations: option_informations)
    end 

    # creation of Rental objects
    rentals = @json_input.dig('rentals').map do |rental_informations|
      Rental.new(informations: rental_informations)
    end 
   
    # creation of Price objects 
    prices = rentals.map do |rental|
      Price.new(rental: rental, 
                car: Car.new(informations: hash_cars[rental.car_id])) 
    end 

    # creation of our final json output
    final_prices = {}
    arr_rentals = []
    prices.each do |price|
      arr_rentals << { "id": price.rental_id,
                        "options": price.linked_options,
                        "actions": [
                          {
                            "who": "driver",
                            "type": "debit",
                            "amount": price.rental_price
                          },
                          {
                            "who": "owner",
                            "type": "credit",
                            "amount": price.owner_credit
                          },
                          {
                            "who": "insurance",
                            "type": "credit",
                            "amount": price.insurance_fee
                          },
                          {
                            "who": "assistance",
                            "type": "credit",
                            "amount": price.assistance_fee
                          },
                          {
                            "who": "drivy",
                            "type": "credit",
                            "amount": price.drivy_fee
                          }
                        ] 
                      }
    end 
    final_prices["rentals"] = arr_rentals
    final_prices
  end 
end 