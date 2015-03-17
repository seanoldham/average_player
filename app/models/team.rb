# After scraping, save team info to db
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
