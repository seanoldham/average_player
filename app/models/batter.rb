# == Schema Information
#
# Table name: batters
#
#  id            :integer          not null, primary key
#  first_name    :string           not null
#  last_name     :string           not null
#  bats          :integer          not null
#  throws        :integer          not null
#  pos           :integer          not null
#  jersey_number :integer
#  team_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Batter < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :team
  has_one :batter_stat, foreign_key: :batter_id

  include Scrapable

  BATS = {
    'R' => 0,
    'L' => 1,
    'S' => 2
  }.freeze

  THROWS = {
    'R' => 0,
    'L' => 1
  }.freeze

  POS = {
    'D'  => 0,
    'P' => 1,
    'C'  => 2,
    '1B' => 3,
    '2B' => 4,
    '3B' => 5,
    'SS' => 6,
    'LF' => 7,
    'CF' => 8,
    'RF' => 9,
    'O'  => 10
  }.freeze

  class << self
    def create_or_update(batter)
      batter.each do |b|
        attr = normarize(b.attributes)
        batter = find_or_initialize_by(id: attr[:id])
        batter.update!(attr)
      end
    end

    def league_average
      total_atbats = Batter.all.includes(:batter_stat).sum(:ab).to_d
      total_hits = Batter.all.includes(:batter_stat).sum(:h).to_d
      return total_average = total_hits / total_atbats
    end

    def qualified_atbats
      Batter.includes(:batter_stat).only(:tpa, :league_games, :qualified).each do |batter|
        batter.batter_stat.qualified = batter.batter_stat.tpa >= batter.batter_stat.league_games * 3.1
        batter.batter_stat.save!
      end
    end

    def find_average_batters
      max = self.league_average.to_d + 0.050
      min = self.league_average.to_d - 0.050
      average_list = {}
      Batter.includes(:batter_stat).only(:qualified, :avg_sort).each do |batter|
        if batter.batter_stat.qualified
          if batter.batter_stat.avg_sort.to_d.between?(min, max)
            average_list[batter.id] = batter.batter_stat.avg_sort
          end
        end
      end
      return average_list
    end

    def find_mr_average
      # Iterate through the hash and find the absolute value difference between the current value and the league average. I can create a variable to hold the lowest value, but how do I know which batter ID "wins"?
      diff = 100.0
      winner_id = 0
      self.find_average_batters.each do |k,v|
        math = (v - self.league_average).abs
        if math < diff
          diff = math
          winner_id = k
        end
      end
      return winner_id
    end

    def save_snapshot
      self.find_average_batters
      new_snapshot = Snapshot.new
      new_snapshot.league_average = self.league_average
      new_snapshot.mr_average_id = self.find_mr_average
      new_snapshot.save!
    end

    private

    def normarize(attr)
      normarized = {}
      attr.each do |_, v|
        key = v.name.downcase
        v = v.value
        key, v = name_to_first_name(key, v) if key == 'name_display_first_last'
        v = convert_value(key, v)
        normarized[key.to_sym] = v if Batter.attribute_names.include? key
      end
      normarized
    end

    def name_to_first_name(k, v)
      v = v.gsub!(/\s.*/, '')
      ['first_name', v]
    end

    def convert_value(k, v)
      case k
      when 'bats'
        return BATS[v]
      when 'pos'
        return POS[v]
      when 'throws'
        return THROWS[v]
      when 'id'
        return v.to_i
      else
        return v
      end
    end
  end
end
