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
    case choice
    when "a"
      @human_player.search_weapon
    when "s"
      @human_player.search_health_pack
    else
      index = choice.to_i
      if index < @enemies_in_sight.length && index >= 0
        target = @enemies_in_sight[index]
        @human_player.attacks(target)
        if target.life_points <= 0
          kill_player(target)
          @players_left -= 1
        end
      else
        puts "Commande invalide, tu trébuches dans le vide !"
      end
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