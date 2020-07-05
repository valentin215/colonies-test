class Car
  attr_reader :informations, :id, :price_per_day, :price_per_km

  def initialize(informations:)
    @informations = informations
    @id = informations['id']
    @price_per_day = informations['price_per_day']
    @price_per_km = informations['price_per_km']
  end 
end 