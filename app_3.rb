require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

puts "------------------------------------------------"
puts "|   BIENVENUE DANS L'ARÈNE ULTIME (V3.0)       |"
puts "------------------------------------------------"

puts "Entre ton nom de combattant :"
print "> "
my_game = Game.new(gets.chomp)

while my_game.is_still_ongoing?
  puts "\n================================================"
  my_game.show_players
  my_game.new_players_in_sight
  
  my_game.menu
  print "\nTon choix ? > "
  my_game.menu_choice(gets.chomp)

  my_game.enemies_attack if my_game.is_still_ongoing?
  
  puts "\nAppuie sur Entrée pour le prochain tour..."
  gets.chomp
end

while my_game.is_still_ongoing?
  system("clear") || system("cls")
  
  my_game.show_players
  my_game.new_players_in_sight
  
  my_game.menu
end

my_game.end_game