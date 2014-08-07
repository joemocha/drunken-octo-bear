# encoding: UTF-8
require './player'
require 'pry'

# load players
Player.load
puts "*" * 80
puts Stats::MostImprovedBattingAvg.new(2009, 2010)
puts "*" * 80
puts Stats::SluggingAvgByTeam.new("OAK", 2007)
puts "*" * 80
puts Stats::TripleCrownWinner.new("AL", 2011)
puts Stats::TripleCrownWinner.new("AL", 2012)
puts Stats::TripleCrownWinner.new("NL", 2011)
puts Stats::TripleCrownWinner.new("NL", 2012)
puts "*" * 80
