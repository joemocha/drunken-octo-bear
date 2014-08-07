module Stats
  class MostImprovedBattingAvg
    attr :player, :first_year, :last_year, :diff
    def initialize(first_year, last_year)
      @first_year = first_year
      @last_year = last_year
      @diff = 0.0
      Player.ids.each do |id|
        player = Player.all[id]
        next unless player_eligible?(player)
        first_avg = player.stat_year(first_year).batting_avg
        last_avg = player.stat_year(last_year).batting_avg
        if last_avg > first_avg
          diff_avg = last_avg - first_avg
          if diff_avg > @diff
            @player = player
            @diff = diff_avg
          end
        end
      end
    end

    def player_eligible?(p)
        !p.nil? &&
        !p.stat_year(first_year).nil? &&
        !p.stat_year(last_year).nil? &&
        p.stat_year(first_year).ab >= 200 &&
        p.stat_year(last_year).ab >= 200
    end

    def to_s
      "Most Improved Player from #{first_year}-#{last_year} is #{player} (#{diff})"
    end
  end

  class SluggingAvgByTeam
    def initialize(team, year)
      @year = year
      @team = team
      players = Player.all.find_all{|id, p| p.played_for?(@team, @year) }
      @avg = players.inject(0) do |sum, (id, p)|
        stat = p.stats_for_team_and_year(@team, @year)[@year]
        sum + stat.slugging_avg
      end.to_f / players.size
    end

    def to_s
      "Slugging avg for the #{@year} #{@team} is #{@avg}"
    end
  end

  class Year
    def initialize(hash={})
      hash.each{|k,v| hash[k] = 0 if v.nil? }
      @hash = hash
      generate_stats
    end

    def to_s
      str = ""
      @hash.each do |k,v|
        str << "#{k}: #{v}\n"
      end
      str
    end

    private
    def generate_stats
      set_batting_avg
      set_slugging_avg
    end

    def set_batting_avg
      @hash[:batting_avg] = if ab == 0
                              0.0
                            else
                              h / ab.to_f
                            end

    end

    def set_slugging_avg
      @hash[:slugging_avg] = if ab == 0
                               0.0
                             else
                               ((h - @hash[:'2b'] - @hash[:'3b'] - hr) +
                                2 * @hash[:'2b'] +
                                3 * @hash[:'3b'] +
                                4 * hr
                               ) / ab.to_f
                             end

    end

    def method_missing(method_sym, *args, &block)
      if @hash[method_sym].nil?
        super
      else
        self.class.send :define_method, method_sym do
          @hash[method_sym]
        end
        send method_sym
      end
    end
  end


  class TripleCrownWinner
    attr :player, :year, :league
    def initialize(league, year)
      @league = league
      @year = year
    end

    def to_s
      "The #{league} #{year} Triple Crown winner is #{player}"
    end
  end
end
