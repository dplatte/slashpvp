class Character < ActiveRecord::Base
  has_many :match_histories
  belongs_to :region
  belongs_to :bracket
  belongs_to :character_spec
  belongs_to :character_class
  belongs_to :character_race
  belongs_to :gender
  belongs_to :faction


  def self.updateLadder(r, b)
    time = Time.now
    region = Region.find_by_abbr(r.downcase)
    bracket = Bracket.find_by_name(b.downcase)
    if(region && bracket)
      api_key = Rails.application.secrets.battlenet_api_key
      resp = HTTParty.get('https://' + region.abbr + '.api.battle.net/wow/leaderboard/' + bracket.name + '?locale=' + region.locales.first.abbr + '&apikey=' + api_key, timeout: 30)
      if(resp.success?)
        response = JSON.parse(resp.body)['rows']

        unchangedCharacterIds = Character.where(bracket_id: bracket.id, region_id: region.id).pluck(:id)

        groupTime = DateTime.now
        response.each do |s|

          #create and/or select character
          character = Character.where(name: s['name'], realm_name: s['realmName'], bracket_id: bracket.id, region_id: region.id).first_or_initialize

          #check for recent match
          if(character.season_wins != nil && s['seasonWins'] == character.season_wins + 1 && s['seasonLosses'] == character.season_losses && character.ranking != nil)
            MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: true, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: s['rating'] - character.rating, rank_change: character.ranking - s['ranking'], retrieved_time: groupTime)
          elsif (character.season_losses != nil && s['seasonLosses'] == character.season_losses + 1 && s['seasonWins'] == character.season_wins  && character.ranking != nil)
            MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: false, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: character.rating - s['rating'], rank_change: s['ranking'] - character.ranking, retrieved_time: groupTime)
          end

          #update character
          character.update_attributes(gender_id: s['genderId'], character_race_id: s['raceId'], character_class_id: s['classId'], character_spec_id: s['specId'], faction_id: s['factionId'], rating: s['rating'], ranking: s['ranking'], season_wins: s['seasonWins'], season_losses: s['seasonLosses'], weekly_wins: s['weeklyWins'], weekly_losses: s['weeklyLosses'])
          unchangedCharacterIds.delete(character.id)

        end

        #clean up characters that fell off the ladder
        unchangedCharacters = Character.where.not(ranking: nil).where(id: unchangedCharacterIds, bracket_id: bracket.id, region_id: region.id)
        unchangedCharacters.each do |c|
          c.update_attributes(ranking: nil)
        end
      end
    end

    time = Time.now - time

    Rails.logger.info(groupTime.to_s + ': Cron job took ' + time.to_s + ' seconds to update the ' + region.name + ' ' + b + ' ladder.')

    return true
  end
end
