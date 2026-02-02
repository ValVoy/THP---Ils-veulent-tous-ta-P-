class Player
  attr_accessor :name, :life_points

  def initialize(name)
    @name = name
    @life_points = 10
  end

  def show_state
    puts "#{@name} a #{@life_points} points de vie"
  end

  def gets_damage(damage_received)
    @life_points -= damage_received
    if @life_points <= 0
      @life_points = 0
      puts "Le joueur #{@name} a été tué !"
    end
  end

  def attacks(player_to_attack)
    puts "Le joueur #{@name} attaque le joueur #{player_to_attack.name}"
    damage = compute_damage
    puts "Il lui inflige #{damage} points de dommages"
    player_to_attack.gets_damage(damage)
  end

  def compute_damage
    return rand(1..6)
  end
end