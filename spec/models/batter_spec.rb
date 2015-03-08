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

require 'spec_helper'

describe Batter do
  describe '#normarize' do
    url = 'http://gd2.mlb.com/components/team/stats/114-stats.xml'
    let(:attr){
      VCR.use_cassette 'team-stats' do
        Nokogiri::XML.parse(open(url)).css('batter').first.attributes
      end
    }

    it do
      Batter.attribute_names.map(&:to_sym).
        reject{|attr| attr == :created_at || attr == :updated_at}.each do |e|
        expect( Batter.send(:normarize, attr) ).to include e
      end
    end
  end
end
