require 'date'
require_relative 'option'

class Rental
  attr_reader :informations, :id, :car_id, :start_date, :end_date, :distance, :options
  private :informations, :start_date, :end_date

  def initialize(informations:)
    @informations = informations
    @id = informations['id']
    @car_id = informations['car_id']
    @start_date = Date.parse(informations['start_date'])
    @end_date = Date.parse(informations['end_date'])
    @distance = informations['distance']
    @options = linked_options
  end 

  def rental_days
    # we add + 1 to get the proper number of rental days 
    (@end_date - @start_date).to_i + 1
  end
  
  def linked_options
    # rental class has many options, we grab them thanks to this method
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

  def has_owner_credit_options
    # this method help us to know if the rental has options linked to the owner
    options.each do |option|
      return true if option.type == 'gps' || option.type == 'baby_seat' 
    end
    false 
  end

  def has_drivy_credit_options
    # this method help us to know if the rental has options linked to drivy
    options.each do |option|
      return true if option.type == 'additional_insurance'
    end
    false 
  end 
end 