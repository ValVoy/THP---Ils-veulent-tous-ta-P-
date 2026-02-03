require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

puts "------------------------------------------------"
puts "Bienvenue sur 'ILS VEULENT TOUS MA POO' !"
puts "Le but du jeu est d'être le dernier survivant !"
puts "------------------------------------------------"

# Initialisation du joueur humain
puts "Quel est ton prénom, guerrier ?"
print "> "
name = gets.chomp
user = HumanPlayer.new(name)

# Initialisation des ennemis
enemies = [Player.new("Josiane"), Player.new("José")]

# Boucle de jeu
while user.life_points > 0 && (enemies[0].life_points > 0 || enemies[1].life_points > 0)
  puts "\n-------------------------------------------------"
  user.show_state
  
  # Menu d'action
  puts "\nQuelle action veux-tu effectuer ?"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner"
  puts "\nattaquer un joueur en vue :"
  enemies.each_with_index do |enemy, index|
    print "#{index} - "
    enemy.show_state
  end

  print "> "
  choice = gets.chomp

  case choice
  when "a"
    user.search_weapon
  when "s"
    user.search_health_pack
  when "0"
    user.attacks(enemies[0])
  when "1"
    user.attacks(enemies[1])
  else
    puts "Action inconnue, tu passes ton tour par maladresse !"
  end

  puts "\nLes autres joueurs t'attaquent !"
  enemies.each do |enemy|
    if enemy.life_points > 0
      enemy.attacks(user)
    end
  end
  
  puts "\nAppuie sur Entrée pour continuer..."
  gets.chomp
end

puts "\nLa partie est finie"
if user.life_points > 0
  puts "BRAVO ! TU AS GAGNE !"
else
  puts "Loser ! Tu as perdu !"
end