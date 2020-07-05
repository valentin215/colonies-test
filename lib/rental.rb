require 'date'
require_relative 'option'

class Rental
  attr_accessor :informations, :id, :car_id, :start_date, :end_date, :distance, :options

  def initialize(informations:)
    @informations = informations
    @id = informations['id']
    @car_id = informations['car_id']
    @start_date = Date.parse(informations['start_date'])
    @end_date = Date.parse(informations['end_date'])
    @distance = informations['distance']
    @options = find_options
  end 

  def rental_days
    (@end_date - @start_date).to_i + 1
  end
  
  def find_options
    @find_options ||= begin
      arr = []
      Option.all.each do |option|
        next if option.rental_id != id
        arr << option
      end
      arr
    end 
  end 

  def group_options
    options.map do |option|
      option.type
    end
  end 

  def has_options
    options.any?
  end 

  def has_owner_fee_options
    options.each do |option|
      return true if option.type == 'gps' || option.type == 'baby_seat' 
    end
    false 
  end

  def has_drivy_fee_options
    options.each do |option|
      return true if option.type == 'additional_insurance'
    end
    false 
  end 

  def options_price
    @options_price ||= begin
      if self.has_options
        self.options.map do |option|
          (option.price_per_day * self.rental_days)
        end.sum 
      else
        0
      end
    end 
  end  

  
  def owner_options_credit
    if self.has_owner_fee_options
      self.options.map do |option|
        next if option.type == 'additional_insurance'
        (option.price_per_day * self.rental_days)
      end.sum 
    else
      0
    end
  end

  def drivy_options_credit
    if self.has_drivy_fee_options
      self.options.map do |option|
        next if option.type != 'additional_insurance'
        (option.price_per_day * self.rental_days)
      end.sum
     else 
      0
    end 
  end 
end 