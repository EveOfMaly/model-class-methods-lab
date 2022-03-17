class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    # all.limit(5)
    Boat.all[0...5]
  end

  def self.dinghy
    # where("length < 20")
    Boat.all.select {|boat| boat.length < 20}
  end

  def self.ship
    # where("length >= 20")
    Boat.all.select {|boat| boat.length >= 20}
  end

  def self.last_three_alphabetically
    # all.order(name: :desc).limit(3)
    Boat.all.sort {| a, b | a.name <=> b.name }.last(3).reverse
  end

  def self.without_a_captain
    # where(captain_id: nil)
    Boat.all.select {|boat| boat.captain == nil } 
  end

  def self.sailboats
    Classification.where(name: "Sailboat").first.boats
  end
   
  def self.with_three_classifications
    # This is really complex! It's not common to write code like this
    # regularly. Just know that we can get this out of the database in
    # milliseconds whereas it would take whole seconds for Ruby to do the same.
    #
    # joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
    
  
    # Boat.all.select {|boat| boat.classifications.count == 3}
     joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
    

  end

  def self.non_sailboats
    where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    order('length DESC').first
  end
end
