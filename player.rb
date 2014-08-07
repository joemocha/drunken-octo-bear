# encoding: UTF-8
require 'csv'
require './stats'

class Player
  NAME_FILE = "Master-small.csv"
  STAT_FILE = "Batting-07-12g.csv"
  class << self
    def load
      return unless @ids.nil?
      @ids = []
      @players = {}
      name_file = File.join(File.dirname(__FILE__), NAME_FILE)
      CSV.foreach( name_file, headers: true, header_converters: :symbol, converters: :numeric) do |line|
        @ids << line[:playerid]
        @players[line[:playerid]] = new(line.to_hash)
      end

      stat_file = File.join(File.dirname(__FILE__), STAT_FILE)
      CSV.foreach( stat_file, headers: true, header_converters: :symbol, converters: :numeric) do |line|
        player = @players[line[:playerid]]
        stats = line.to_hash.reject do |k,v|
          [:playerid, :yearid].include?(k)
        end
        player.add_year_stat(line[:yearid], stats)
      end
    end

    def all
      @players
    end

    def ids
      @ids
    end
  end

  attr :id, :stats, :birthyear, :namefirst, :namelast
  def initialize(hash={})
    @stats = {}
    @id = hash[:playerid]
    @birthyear = hash[:birthyear]
    @namefirst = hash[:namefirst]
    @namelast = hash[:namelast]
  end

  def add_year_stat(year, data)
    stats[year] = Stats::Year.new(data)
  end

  def stat_year(year)
    stats[year]
  end

  def stats_for_team_and_year(team, year)
    stats.select do |stat|
      stat.teamid == team && stat.yearid == year
    end
  end

  def played_for?(team, year)
    stats.any? do |stat|
      stat.teamid == team && stat.yearid == year
    end
  end

  def to_s
    str = "#{namefirst} #{namelast} (#{birthyear}) <#{id}>"
    # stats.each do |year, stat|
      # str << stat.to_s
    # end
    str
  end

end
