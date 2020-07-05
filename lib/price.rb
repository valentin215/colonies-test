require_relative 'car'
require_relative 'rental'
require_relative 'option'

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

  def linked_options
    rental.group_options
  end 

  def rental_price
    @rental_price ||= begin
      (total_price) + (car.price_per_km * rental.distance)
    end 
  end
  
  def insurance_fee
    (rental_price_without_options * (30/100.to_f) / 2).to_i
  end 

  def assistance_fee
    rental.rental_days * 100
  end 

  def drivy_fee
    (drivy_fee_without_options) + drivy_options_credit
  end 

  def owner_credit
    (rental_price_without_options) - (insurance_fee + assistance_fee + (drivy_fee_without_options)) + owner_options_credit
  end 

  private
  
  def rental_price_without_options
    rental_price - options_price
  end 

  def drivy_fee_without_options
    insurance_fee - assistance_fee
  end 

  def total_price
    if rental.rental_days > 1 && rental.rental_days < 5
      price_after_one_day
    elsif rental.rental_days >= 5 && rental.rental_days < 10
      price_after_four_days
    elsif rental.rental_days > 10
      price_after_ten_days
    else 
      car.price_per_day + options_price
    end 
  end
  
  def price_after_one_day
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * (rental.rental_days - 1) + options_price
  end 

  def price_after_four_days
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * 3 + (car.price_per_day - (car.price_per_day * 30/100)) * (rental.rental_days - 4) + options_price
  end 

  def price_after_ten_days
    car.price_per_day + (car.price_per_day - (car.price_per_day * 10/100)) * 3 + (car.price_per_day - (car.price_per_day * 30/100)) * 6 + (car.price_per_day - (car.price_per_day * 50/100)) * (rental.rental_days - 10) + options_price
  end 

  def options_price
    @options_price ||= begin
      if rental.has_options
        rental.options.map do |option|
          (option.price_per_day * rental.rental_days)
        end.sum 
      else
        0
      end
    end 
  end
  
  def owner_options_credit
    if rental.has_owner_credit_options
      rental.options.map do |option|
        next if option.type == 'additional_insurance'
        (option.price_per_day * rental.rental_days)
      end.sum 
    else
      0
    end
  end
  
  def drivy_options_credit
    if rental.has_drivy_credit_options
      rental.options.map do |option|
        next if option.type != 'additional_insurance'
        (option.price_per_day * rental.rental_days)
      end.sum
     else 
      0
    end 
  end 
end 