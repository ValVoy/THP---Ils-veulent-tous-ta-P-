require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

puts "------------------------------------------------"
puts "|   BIENVENUE DANS L'ARÈNE ULTIME (V3.0)       |"
puts "------------------------------------------------"

print "Entre ton nom de combattant : "
name = ""
while name == ""
  name = gets.chomp.strip
  if name == ""
    print "Le nom ne peut pas être vide. Entre un nom : "
  end
end

my_game = Game.new(name)

while my_game.is_still_ongoing?
  system("clear") || system("cls") 
  
  my_game.show_players
  my_game.new_players_in_sight
  
  action_valid = false
  while action_valid == false
    my_game.menu
    print "\nTon choix ? > "
    choice = gets.chomp
    
    action_valid = my_game.menu_choice(choice)
  end

  if my_game.is_still_ongoing?
    my_game.enemies_attack
    puts "\nAppuie sur Entrée pour le prochain tour..."
    gets.chomp
  end
end

my_game.end_game