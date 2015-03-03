# == Schema Information
#
# Table name: batters
#
#  id            :integer          not null, primary key
#  first_name    :string(255)      not null
#  last_name     :string(255)      not null
#  bats          :integer          not null
#  throws        :integer          not null
#  pos           :integer          not null
#  jersey_number :integer          not null
#  team_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_batters_on_id       (id) UNIQUE
#  index_batters_on_team_id  (team_id)
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

    def batter_average
      Batter.all.each do |batter|
        total_atbats = 0.000
        total_hits = 0.000
        total_atbats += batter.batter_stat.ab
        total_hits += batter.batter_stat.h
        average = total_hits / total_atbats
        batter.batter_stat.batting_average = average.round(4)
        batter.batter_stat.save!
      end
    end

    def league_average
      total_atbats = 0.000
      total_hits = 0.000
      Batter.all.each do |batter|
        total_atbats += batter.batter_stat.ab
        total_hits += batter.batter_stat.h
      end
      return total_average = total_hits / total_atbats
    end

    def qualified_atbats
      Batter.all.each do |batter|
        if batter.batter_stat.tpa >= batter.batter_stat.league_games * 3.1
          batter.batter_stat.qualified = false
          batter.batter_stat.save!
        end
      end
    end

    def find_average_batters
      max = (self.league_average * 100000) + 1000
      min = (self.league_average * 100000) - 1000
      average_list = {}
      Batter.all.each do |batter|
        if !batter.batter_stat.qualified 
          if (batter.batter_stat.batting_average * 100000).to_i.between?(min.to_i, max.to_i)
            average_list["#{batter.first_name} #{batter.last_name}"] = batter.batter_stat.batting_average
          end
        end
      end
      return average_list
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
