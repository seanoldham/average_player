namespace :scrape do
  require 'open-uri'
  BASE_URL = 'http://gd2.mlb.com/'
  TEAM_ID = ((108..121).to_a + (133..147).to_a + [158]).freeze

  desc 'get all'
  task all: ['team:get', 'batter:get', 'data:get']

  namespace :team do
    desc 'get Team'
    task get: :environment do
      get_doc do |team|
        Team.create_or_update(team)
      end
    end
  end

  namespace :batter do
    desc 'get batter'
    task get: :environment do
      get_doc do |doc|
        batter = doc.css('batter')
        Batter.create_or_update(batter)
        BatterStat.create_or_update(batter)
      end
    end
  end

  namespace :data do
    desc 'crunch numbers'
    task get: :environment do
      @avg = Batter.league_average.round(3).to_s[1..-1]
      @qualified = Batter.qualified_atbats
      @average_list = Batter.find_average_batters
      @snapshot = Batter.save_snapshot
    end
  end

  def get_doc(&block)
    TEAM_ID.each do |team_id|
      uri = BASE_URL +
        "components/team/stats/year_2018/#{team_id}-stats.xml"
      doc = Nokogiri::XML.parse(open(uri)).css('TeamStats')
      yield doc
    end
  end
end
