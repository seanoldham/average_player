# == Schema Information
#
# Table name: batter_stats
#
#  id              :integer          not null, primary key
#  batter_id       :integer          not null
#  h               :integer          not null
#  ab              :integer          not null
#  tb              :integer          not null
#  r               :integer          not null
#  b2              :integer          not null
#  b3              :integer          not null
#  hr              :integer          not null
#  rbi             :integer          not null
#  sac             :integer          not null
#  sf              :integer          not null
#  hbp             :integer          not null
#  bb              :integer          not null
#  ibb             :integer          not null
#  so              :integer          not null
#  sb              :integer          not null
#  cs              :integer          not null
#  gidp            :integer          not null
#  np              :integer          not null
#  go              :integer          not null
#  ao              :integer          not null
#  tpa             :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#  batting_average :float
#  league_games    :integer
#  qualified       :boolean          default("true")
#

class BatterStat < ActiveRecord::Base
  include Scrapable
  belongs_to :batter

  class << self
    def create_or_update(batter)
      batter.each do |b|
        attr = normarize(b.attributes)
        stats = find_or_initialize_by(batter_id: attr[:batter_id])
        stats.update!(attr)
      end
    end

    private

    def normarize(attr)
      normarized = {}
      attr.each do |_, v|
        key = v.name.downcase
        v = v.value
        key = 'batter_' + key if key == "id"
        normarized[key.to_sym] = v.to_d if BatterStat.
          attribute_names.include? key
      end
      normarized
    end
  end
end
