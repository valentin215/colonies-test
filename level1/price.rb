require_relative 'car'
require_relative 'rental'

class Price
  attr_accessor :rental, :car
  private :rental, :car

  def initialize(rental:, car:)
    @rental = rental
    @car = car
  end 

  def rental_id
    rental.id
  end 

  def rental_price
    (car.price_per_day * rental.rental_days) + (car.price_per_km * rental.distance)
  end 
end 