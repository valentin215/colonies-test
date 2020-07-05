class Option
  attr_reader :informations, :id, :rental_id, :type
  private :informations

  OPTIONS = []

  def initialize(informations:)
    @informations = informations
    @id = informations['id']
    @rental_id = informations['rental_id']
    @type = informations['type']
    OPTIONS << self 
  end

  def self.all
    OPTIONS
  end 

  def price_per_day
    if type == "gps"
      500
    elsif type == "baby_seat"
      200
    else
      1000
    end 
  end 
end 