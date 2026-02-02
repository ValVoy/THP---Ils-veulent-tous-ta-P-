require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

player1 = Player.new("Josiane")
player2 = Player.new("José")

puts "Voici l'état de chaque joueur :"
player1.show_state
player2.show_state

puts "\nPassons à la phase d'attaque :"

while player1.life_points > 0 && player2.life_points > 0
  player1.attacks(player2)
  # On vérifie si player2 est mort pour arrêter le combat immédiatement
  break if player2.life_points <= 0
  
  player2.attacks(player1)
  puts "\nVoici l'état de nos joueurs :"
  player1.show_state
  player2.show_state
  puts "-" * 20
end

