# encoding: UTF-8
require './player'
require 'pry'

# load players
Player.load
# binding.pry
puts "*" * 80
player = Stats::MostImprovedBattingAvg.new(2009, 2010)
puts player
puts "*" * 80
# team = Stats::SluggingAvgByTeam.new(2007, "OAK")
# puts team
puts "*" * 80
puts "Triple Crown Winners for 2011 and 2012"
puts "AL Winner: "
puts "NL Winner: "
puts "*" * 80