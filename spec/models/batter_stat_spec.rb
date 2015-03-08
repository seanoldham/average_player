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

require 'spec_helper'

describe BatterStat do
  describe 'normarize' do
    url = 'http://gd2.mlb.com/components/team/stats/114-stats.xml'
    let(:attr){
      VCR.use_cassette 'team-stats' do
        Nokogiri::XML.parse(open(url)).css('batter').first.attributes
      end
    }

    it do
      BatterStat.attribute_names.map(&:to_sym).
        reject{|a| a == :id || a == :created_at || a == :updated_at}.each do |e|

        expect( BatterStat.send(:normarize, attr) ).to include e
      end
    end
  end
end
