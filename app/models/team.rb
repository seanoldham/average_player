# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  league_id  :integer          not null
#  name       :string           not null
#  abbrev     :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class Team < ActiveRecord::Base
  self.primary_key = :id
  include Scrapable
  TEAM_ID = ((108..121).to_a + (133..147).to_a + [158]).freeze
  has_many :batters, foreign_key: :team_id
  class << self
    def create_or_update(doc)
      attr = normarize(doc.first.attributes)
      team = find_or_initialize_by(id: attr[:id])
      team.update!(attr)
    end

    private

    def normarize(attr)
      normarized = {}
      attr.each do |_, v|
        key = v.name.gsub(/team_/, '')
        v = v.value
        v = v.to_i if key == 'id'
        normarized[key.to_sym] = v if Team.attribute_names.include? key
      end
      normarized
    end
  end
end
