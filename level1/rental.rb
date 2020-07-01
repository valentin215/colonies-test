require 'date'

class Rental
  attr_accessor :informations, :id, :car_id, :start_date, :end_date, :distance

  def initialize(informations:)
    @informations = informations
    @id = informations['id']
    @car_id = informations['car_id']
    @start_date = Date.parse(informations['start_date'])
    @end_date = Date.parse(informations['end_date'])
    @distance = informations['distance']
  end 

  def rental_days
    (@end_date - @start_date).to_i + 1
  end 
end 