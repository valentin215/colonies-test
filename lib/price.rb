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
    @rental_price ||= begin
      (total_price_per_day) + (car.price_per_km * rental.distance)
    end 
  end
  
  def insurance_fee
    (rental_price * (30/100.to_f) / 2).to_i
  end 

  def assistance_fee
    rental.rental_days * 100
  end 

  def drivy_fee
    insurance_fee - assistance_fee
  end 

  private 

  def total_price_per_day
    if rental.rental_days > 1 && rental.rental_days < 5
      price_after_one_day
    elsif rental.rental_days >= 5 && rental.rental_days < 10
      price_after_four_days
    elsif rental.rental_days > 10
      price_after_ten_days
    else 
      car.price_per_day
    end 
  end
  
  def price_after_one_day
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * (rental.rental_days - 1)
  end 

  def price_after_four_days
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * 3 + (car.price_per_day - (car.price_per_day * 30/100)) * (rental.rental_days - 4)
  end 

  def price_after_ten_days
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * 3 + (car.price_per_day - (car.price_per_day * 30/100)) * 6 + (car.price_per_day - (car.price_per_day * 50/100)) * (rental.rental_days - 10)
  end 
end 