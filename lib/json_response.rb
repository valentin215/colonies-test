require 'json'
require_relative 'car'
require_relative 'price'
require_relative 'rental'
require_relative 'option'

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


    hash_options = @json_input.dig('options').group_by do |option_informations|
      option_informations['rental_id']
    end 

    @json_input.dig('options').each do |option_informations|
      Option.new(informations: option_informations)
    end 

    rentals = @json_input.dig('rentals').map do |rental_informations|
      # Rental.new(informations: rental_informations, 
      #            options: Option.new(informations: hash_options[rental_informations['id']]))
      Rental.new(informations: rental_informations)
    end 
   
    prices = rentals.map do |rental|
      Price.new(rental: rental, 
                car: Car.new(informations: hash_cars[rental.car_id])) 
    end 

    final_prices = {}
    arr_rentals = []
    prices.each do |price|
      arr_rentals << { "id": price.rental_id,
                        "options": [],
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