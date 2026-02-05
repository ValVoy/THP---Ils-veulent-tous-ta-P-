=begin 
class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(name)
    @human_player = HumanPlayer.new(name)
    @players_left = 10 
    @enemies_in_sight = [] 
  end

  def kill_player(player)
    @enemies_in_sight.delete(player)
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && (@players_left > 0 || !@enemies_in_sight.empty?)
  end

  def new_players_in_sight
    return puts "Tous les joueurs sont déjà en vue." if @enemies_in_sight.length == @players_left

    dice = rand(1..6)
    case dice
    when 1
      puts "Aucun nouveau joueur adverse n'arrive."
    when 2..4
      create_enemy
      puts "Un nouvel adversaire arrive en vue !"
    when 5..6
      2.times { create_enemy }
      puts "Attention, 2 nouveaux adversaires déboulent !"
    end
  end

  def create_enemy
    if @enemies_in_sight.length < @players_left
      random_id = rand(1000..9999)
      @enemies_in_sight << Player.new("joueur_#{random_id}")
    end
  end

  def menu
    puts "\n" + "┌" + "─"*20 + " ACTIONS " + "─"*21 + "┐"
    puts "│  [a] Chercher une arme         [s] Se soigner    │"
    puts "└" + "─"*50 + "┘"
    
    if @enemies_in_sight.any?
      puts "\nCIBLES DISPONIBLES :"
      @enemies_in_sight.each_with_index do |enemy, index|
        health_bar = "█" * (enemy.life_points) + "░" * (10 - enemy.life_points)
        puts "  #{index} - #{enemy.name.ljust(15)} [#{health_bar}] #{enemy.life_points} PV"
      end
    else
      puts "\n(Aucun ennemi à portée pour l'instant...)"
    end
    puts "─"*51
  end

  def menu_choice(choice)
    if choice == "a"
      @human_player.search_weapon
      return true # Action valide
    elsif choice == "s"
      @human_player.search_health_pack
      return true # Action valide
    elsif choice.match?(/^\d+$/)
      index = choice.to_i
      if index >= 0 && index < @enemies_in_sight.length
        target = @enemies_in_sight[index]
        @human_player.attacks(target)
        if target.life_points <= 0
          kill_player(target)
          @players_left -= 1
        end
        return true # Action valide
      else
        puts "\n❌ Erreur : Ce numéro n'est pas dans la liste !"
        return false # Action invalide, on va redemander
      end
    else
      puts "\n❌ Erreur : Commande invalide (choisis a, s, ou un chiffre)."
      return false # Action invalide
    end
  end

  def enemies_attack
    puts "\n--- RIPOSTE DES ENNEMIS ---"
    @enemies_in_sight.each do |enemy|
      enemy.attacks(@human_player) if @human_player.life_points > 0
    end
  end

  def show_players
    puts "\n" + "═"*50
    puts "  STATUT DU HÉROS : #{@human_player.name.upcase}"
    print "  "
    @human_player.show_state
    puts "  RÉSERVE : #{@players_left} ennemis restants"
    puts "═"*50
  end

  def end_game
    puts "\n--- LA PARTIE EST FINIE ---"
    if @human_player.life_points > 0
      puts "VICTOIRE ! Tu as survécu à l'arène."
    else
      puts "GAME OVER... Tu as rejoint le cimetière des POO."
    end
  end
end
=end




class Game
  attr_accessor :human_player, :enemies_in_sight, :palier, :enemies_defeated_in_palier

  def initialize(human_player)
    @human_player = human_player
    @enemies_in_sight = []
    @palier = 1
    @enemies_defeated_in_palier = 0
    @catalog = generate_mega_catalog
  end

  def generate_mega_catalog
    items = []
    stats_map = { str: "Gantelets", dex: "Bottes", con: "Plastron", luck: "Amulette", int: "Diadème" }
    stats_map.each do |stat, name|
      10.times { |i| items << {n: "#{name} +#{i+1}", p: 15 + (i*12), s: stat, v: i+1} }
    end
    # Augmentation de la probabilité des boucliers et AOE
    10.times { |i| items << {n: "Bouclier d'élite +#{i+1}", p: 20 + (i*15), s: :shield, v: (i+1)*2} }
    5.times { |i| items << {n: "Bombe Incendiaire (ZONE)", p: 50 + (i*10), s: :aoe, v: 20 + (i*5)} }
    items << {n: "Lame de Feu", p: 50, s: :eff, v: :burn}
    items << {n: "Dague Toxique", p: 50, s: :eff, v: :poison}
    items << {n: "Potion Max", p: 40, s: :heal, v: 1000}
    items
  end

  def spawn_enemy
    if @enemies_in_sight.length < 7 && rand(1..2) == 1
      # Les ennemis scalent enfin sur le palier !
      @enemies_in_sight << Enemy.new(@palier, @palier + 2)
      puts "🚨 Un nouvel ennemi apparaît !"
    end
  end

  def check_level_up
    next_lvl_xp = 10 + (@human_player.level * 2)
    while @human_player.exp >= next_lvl_xp
      @human_player.level += 1
      @human_player.exp -= next_lvl_xp
      puts "\n🌟 NIVEAU SUPÉRIEUR ! Tu es désormais niveau #{@human_player.level}"
      @human_player.show_state # On montre les stats avant d'ajouter les points
      distribute_lvl_points(3)
      next_lvl_xp = 10 + (@human_player.level * 2)
    end
  end

  def distribute_lvl_points(pts)
    while pts > 0
      puts "\nPoints à distribuer : #{pts}"
      puts "1.Str [#{@human_player.str}] 2.Dex [#{@human_player.dex}] 3.Con [#{@human_player.con}] 4.Luck [#{@human_player.luck}] 5.Int [#{@human_player.int}]"
      print "Choix (1-5) > "
      case gets.chomp.to_i
      when 1 then @human_player.str += 1; pts -= 1
      when 2 then @human_player.dex += 1; pts -= 1
      when 3 then @human_player.con += 1; @human_player.update_max_hp; pts -= 1
      when 4 then @human_player.luck += 1; pts -= 1
      when 5 then @human_player.int += 1; pts -= 1
      end
    end
  end

  def enemy_turn
    puts "\n--- TOUR DES ENNEMIS ---"
    @enemies_in_sight.each do |e|
      if e.is_healer
        # Soigne l'allié qui a le moins de PV, mais sans dépasser son max_hp
        target = @enemies_in_sight.min_by(&:life_points)
        heal = 10 + (e.level * 3)
        old_hp = target.life_points
        target.life_points = [target.life_points + heal, target.max_hp].min
        actual_healed = target.life_points - old_hp
        puts "❇️  #{e.name} soigne #{target.name} (+#{actual_healed} PV)"
      else
        atk = e.compute_damage
        puts "💢 #{e.name} attaque !"
        @human_player.gets_damage(atk[:value])
      end
    end
  end

  def menu_choice(choice)
    case choice
    when "b" then open_shop; return true
    when "s" then @human_player.search_health_pack; return true
    when "f" 
      puts "🌿 Tu fouilles..."; dice = rand(1..6) + @human_player.luck/3
      if dice > 5; @human_player.weapon_level += 1; puts "⚔️ Arme améliorée !"; else puts "Rien."; end
      return true
    else
      if choice.match?(/^\d+$/)
        idx = choice.to_i
        target = @enemies_in_sight[idx]
        return false unless target
        tank = @enemies_in_sight.find { |e| e.is_tank }
        if tank && target != tank; puts "🛡️ Le Tank bloque l'accès !"; return false; end
        @human_player.attacks(target)
        if target.life_points <= 0
          @human_player.exp += target.level
          @enemies_defeated_in_palier += 1
          puts "💀 Tu as vaincu #{target.name} ! (#{target.level} XP)"
          check_loot(target)
          @enemies_in_sight.delete(target)
          check_palier_up # On vérifie si on change de palier
        end
        return true
      end
    end
    false
  end

  def check_palier_up
    if @enemies_defeated_in_palier >= 10
      @palier += 1
      @enemies_defeated_in_palier = 0
      puts "\n🎊 FÉLICITATIONS ! Tu passes au palier #{@palier} ! 🎊"
      puts "Les ennemis seront plus puissants..."
      @human_player.money += 20
      open_shop # Boutique automatique à chaque fin de palier
    end
  end

  def check_loot(enemy)
    roll = rand(1..100) + @human_player.luck
    if roll > 80
      item = @catalog.sample
      puts "🎁 LOOT sur le cadavre : #{item[:n]} !"
      apply_item(item)
    elsif roll > 50
      po = rand(10..30) * enemy.level
      @human_player.money += po
      puts "💰 Tu trouves #{po} PO sur lui."
    end
  end

  def open_shop
    # Rotation de la boutique
    current = @catalog.sample(6)
    loop do
      system("clear")
      puts "🛒 --- BOUTIQUE ITINÉRANTE (Palier #{@palier}) --- (PO: #{@human_player.money})"
      current.each_with_index { |it, i| puts "#{i+1}. #{it[:n].ljust(25)} | #{it[:p]} PO" }
      puts "7. Quitter"
      print "Choix > "
      input = gets.chomp.to_i
      break if input == 7
      item = current[input-1]
      if item && @human_player.money >= item[:p]
        apply_item(item)
        @human_player.money -= item[:p]
        current.delete_at(input-1)
        puts "✅ Acheté !"
        sleep(1)
      end
    end
  end

  def apply_item(item)
    case item[:s]
    when :str then @human_player.str += item[:v]
    when :dex then @human_player.dex += item[:v]
    when :con then @human_player.con += item[:v]; @human_player.update_max_hp
    when :luck then @human_player.luck += item[:v]
    when :int then @human_player.int += item[:v]
    when :shield then @human_player.shield += item[:v]
    when :wpn then @human_player.weapon_level += item[:v]
    when :eff then @human_player.weapon_effect = item[:v]
    when :heal then @human_player.life_points = [@human_player.life_points + item[:v], @human_player.max_life_points].min
    when :aoe 
      puts "\n💥 EXPLOSION DE ZONE ! 💥"
      @enemies_in_sight.each do |e| 
        e.gets_damage(item[:v])
        if e.life_points <= 0
          @human_player.exp += e.level
          @enemies_defeated_in_palier += 1
          puts "💀 #{e.name} a été vaporisé par l'explosion !"
        end
      end
      @enemies_in_sight.reject! { |e| e.life_points <= 0 }
      check_palier_up
    end
    # Mise à jour visuelle du stuff
    if item[:n].include?("+")
      @human_player.equipment[:body] = item[:n] if [:str, :con, :shield].include?(item[:s])
      @human_player.equipment[:head] = item[:n] if [:int, :luck].include?(item[:s])
      @human_player.equipment[:feet] = item[:n] if item[:s] == :dex
    end
  end
end
