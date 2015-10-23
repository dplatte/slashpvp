class Character < ActiveRecord::Base
  has_many :match_histories
  belongs_to :region
  belongs_to :bracket
  has_one :character_spec
  has_one :character_class
  has_one :character_race
  has_one :gender
  has_one :faction


  def updateLadder(r, b)
    ActiveRecord::Base.logger.level = 1

    region = Region.find_by_abbr(r)
    bracket = Bracket.find_by_name(b)
    if(region && bracket)
      api_key = Rails.application.secrets.battlenet_api_key
      resp = HTTParty.get('https://' + region.abbr + '.api.battle.net/wow/leaderboard/' + bracket.name + '?locale=' + region.locales.first.abbr + '&apikey=' + api_key)

      response = JSON.parse(resp.body)['rows']

      unchangedCharacterIds = Character.where(bracket_id: bracket.id).pluck(:id)

      if(response.success?)
        response.each do |s|

          character = Character.where(name: s['name'], realm_name: s['realmName'], bracket_id: bracket.id, region_id: region.id).first_or_initialize
          character.update_attributes(gender_id: s['genderId'], character_race_id: s['raceId'], character_class_id: s['classId'], character_spec_id: s['specId'], faction_id: s['factionId'], rating: s['rating'], ranking: s['ranking'], season_wins: s['seasonWins'], season_losses: s['seasonLosses'], weekly_wins: s['weeklyWins'], weekly_losses: s['weeklyLosses'])
          unchangedCharacterIds.delete(character.id)

        end

        #clean up characters that fell off the ladder
        unchangedCharacters = Character.where.not(ranking: nil).where(id: unchangedCharacterIds, bracket_id: bracket.id)
        unchangedCharacters.each do |c|
          c.update_attributes(ranking: nil)
        end
      end
    end


    return true
  end
end
