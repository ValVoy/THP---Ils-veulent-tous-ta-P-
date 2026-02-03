require 'bundler'
Bundler.require
require_relative 'lib/game'
require_relative 'lib/player'

system("clear")
puts "================================================"
puts "|           THE HACKING RPG V4.3               |"
puts "================================================\n\n"
print "Entre ton nom de héros : "
name = gets.chomp
name = "Voy" if name.strip.empty?

# Initialisation avec stats de base équilibrées
user = HumanPlayer.new(name, {str:2, dex:2, con:2, luck:2, int:2})
game = Game.new(user)
game.distribute_lvl_points(5)

while user.life_points > 0
  system("clear")
  user.apply_status_effects
  break if user.life_points <= 0

  game.spawn_enemy
  game.check_level_up

  puts "🌍 PALIER #{game.palier} | 💀 KILLS : #{game.enemies_defeated_in_palier}/10 | XP #{user.exp}/#{10 + (user.level*2)}"
  user.show_state
  
  valid = false
  while !valid
    puts "\n--- ENNEMIS EN VUE ---"
    if game.enemies_in_sight.empty?
      puts "Aucun ennemi... Repos de courte durée."
    else
      game.enemies_in_sight.each_with_index do |e, i|
        puts " #{i} - #{e.name.ljust(18)} | HP: #{e.life_points}/#{e.max_hp} #{'[TANK]' if e.is_tank} #{'[HEAL]' if e.is_healer}"
      end
    end
    print "\n[b]Shop [s]Soin [f]Fouiller [Num]Attaque > "
    valid = game.menu_choice(gets.chomp)
    puts "⚠️ Saisie invalide ou impossible !" unless valid
  end

  if user.life_points > 0 && !game.enemies_in_sight.empty?
    game.enemy_turn
    puts "\nAppuie sur Entrée pour continuer..."
    gets.chomp
  end
end

system("clear")
puts "💀 GAME OVER. Tu as péri honorablement au Niveau #{user.level}, Palier #{game.palier}."