=begin 
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
    puts "\n⚔️  #{@name} lance une attaque sur #{player_to_attack.name} !"
    damage = compute_damage
    puts "💥 ET BAMMM ! #{damage} points de dégâts."
    player_to_attack.gets_damage(damage)
  end

  def compute_damage
    return rand(1..6)
  end
end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(name)
    @weapon_level = 1 
    super(name)   
    @life_points = 100 
  end

  def show_state
    puts "#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}"
  end

  def compute_damage
    rand(1..6) * @weapon_level
  end

  def search_weapon
    new_weapon_level = rand(1..6)
    puts "Tu as trouvé une arme de niveau #{new_weapon_level}"
    
    if new_weapon_level > @weapon_level
      @weapon_level = new_weapon_level
      puts "Youhou ! elle est meilleure que ton arme actuelle : tu la prends."
    else
      puts "M@*#$... elle n'est pas mieux que ton arme actuelle..."
    end
  end

  def search_health_pack
    dice = rand(1..6)

    if dice == 1
      puts "Tu n'as rien trouvé... "
    elsif dice >= 2 && dice <= 5
      @life_points += 50
      @life_points = 100 if @life_points > 100 
      puts "Bravo, tu as trouvé un pack de +50 points de vie !"
    else
      @life_points += 80
      @life_points = 100 if @life_points > 100
      puts "Waow, tu as trouvé un pack de +80 points de vie !"
    end
  end
end
=end



class Player
  attr_accessor :name, :life_points, :status

  def initialize(name)
    @name = name
    @life_points = 10
    @status = nil
  end

  def apply_status_effects
    return unless @status
    case @status[:type]
    when :poison
      puts "🤢 #{@name} souffre du poison (-5 PV)"
      @life_points -= 5
    when :burn
      puts "🔥 #{@name} brûle (-8 PV)"
      @life_points -= 8
    end
    @status[:duration] -= 1
    @status = nil if @status[:duration] <= 0
  end

  def gets_damage(damage_received)
    @life_points -= damage_received
    @life_points = 0 if @life_points < 0
    puts "💥 #{@name} encaisse #{damage_received} dégâts. (Reste : #{@life_points} PV)"
  end
end

class HumanPlayer < Player
  attr_accessor :str, :dex, :con, :luck, :int, :shield, :exp, :money, :level, :weapon_level, :equipment, :max_life_points, :weapon_effect

  def initialize(name, stats)
    @str = stats[:str]; @dex = stats[:dex]; @con = stats[:con]; @luck = stats[:luck]; @int = stats[:int]
    @exp = 0; @money = 0; @level = 1; @weapon_level = 1; @shield = 0; @weapon_effect = nil
    @equipment = { head: "Rien", body: "Rien", feet: "Rien" }
    super(name)
    update_max_hp
    @life_points = @max_life_points
  end

  def update_max_hp
    @max_life_points = 100 + (@con * 10)
  end

  def weapon_name
    case @weapon_level
    when 1 then "Poings nus 👊"
    when 2 then "Dague rouillée 🗡️"
    when 3 then "Épée de soldat ⚔️"
    when 4 then "Hache de guerre 🪓"
    when 5 then "Lame de cristal 💎"
    else "Excalibur ✨ (Niv.#{@weapon_level})"
    end
  end

  def show_state
    puts "❤️  PV: #{@life_points}/#{@max_life_points} | 🛡️  ARMURE: #{@shield} | 💰 PO: #{@money}"
    puts "💪 Str: #{@str} | 💨 Dex: #{@dex} | 🍀 Luck: #{@luck} | 🧠 Int: #{@int}"
    puts "⚔️  ARME : #{weapon_name} #{"[EFFET: #{@weapon_effect.upcase}]" if @weapon_effect} (x#{@weapon_level})"
    puts "🛡️  STUFF : [Tête: #{@equipment[:head]}] [Corps: #{@equipment[:body]}] [Pieds: #{@equipment[:feet]}]"
  end

  def attacks(target)
    puts "\n⚔️  #{name} attaque #{target.name}..."
    damage = compute_damage
    target.gets_damage(damage)
    
    if @weapon_effect && target.life_points > 0 && rand(1..100) <= 30
      target.status = { type: @weapon_effect, duration: 3 }
      puts "✨ L'effet #{@weapon_effect.upcase} est appliqué sur #{target.name} !"
    end
  end

  def compute_damage
    crit = rand(1..100) <= (@luck * 5)
    base = (rand(1..6) + @str) * @weapon_level
    if crit
      puts "✨ COUP CRITIQUE !"
      return base * 2
    end
    base
  end

  def gets_damage(damage_received)
    actual_damage = [damage_received - @shield, 0].max
    if actual_damage == 0 && damage_received > 0
      puts "🛡️  Ton bouclier a COMPLÈTEMENT bloqué l'attaque !"
      return
    elsif @shield > 0
      puts "🛡️  Ton bouclier réduit les dégâts de #{[damage_received, @shield].min}."
    end

    if rand(1..100) <= (@dex * 4)
      puts "💨 ESQUIVE REUSSIE !"
    else
      super(actual_damage)
    end
  end

  def search_health_pack
    dice = rand(1..10)
    heal_map = { 1=>0, 2=>10, 3=>15, 4=>20, 5=>30, 6=>40, 7=>50, 8=>60, 9=>80, 10=>100 }
    total_heal = heal_map[dice] > 0 ? (heal_map[dice] + (@int * 2) + @luck) : 0
    @life_points = [@life_points + total_heal, @max_life_points].min
    puts "🧪 Dé : #{dice}. Soin de +#{total_heal} PV !"
  end
end

class Enemy < Player
  attr_accessor :level, :type, :dex, :is_tank, :is_healer, :special_atk, :max_hp

  def initialize(min_lvl, max_lvl)
    @level = rand(min_lvl..max_lvl)
    @type = ["Guerrier", "Rôdeur", "Tank", "Soigneur"].sample
    @special_atk = [:poison, :burn, :acid, nil].sample if rand(1..10) > 8
    super("#{@type}_niv.#{@level}")
    setup_stats
    @max_hp = @life_points # On stocke la vie max pour le soin
  end

  def setup_stats
    @is_tank = (@type == "Tank")
    @is_healer = (@type == "Soigneur")
    case @type
    when "Tank" then @life_points = 50 + (@level * 10); @dex = 0
    when "Soigneur" then @life_points = 30 + (@level * 5); @dex = 0
    when "Rôdeur" then @life_points = 20 + (@level * 5); @dex = 10 + (@level * 3)
    when "Guerrier" then @life_points = 40 + (@level * 8); @dex = 5; @str = 8 + (@level * 3)
    end
  end

  def compute_damage
    dmg = case @type
          when "Guerrier" then rand(5..10) + @level * 3
          when "Rôdeur" then rand(3..7) + @level * 2
          when "Tank" then rand(2..4) + @level * 2
          else 0
          end
    {value: dmg, type: @special_atk}
  end
end
 