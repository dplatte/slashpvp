class Character < ActiveRecord::Base
  has_many :match_histories
  has_many :roster_slots
  has_many :teams, :through => :roster_slots
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

    Rails.logger.info(time.to_s + ': Starting cron job for the ' + region.name + ' ' + bracket.name + ' ladder.')

    if(region && bracket)
      api_key = ENV["BATTLE_NET_API_KEY"]
      respTime = Time.now
      resp = HTTParty.get(region.domain + '/wow/leaderboard/' + bracket.name + '?locale=' + region.locales.first.abbr + '&apikey=' + api_key, timeout: 5)
      respTime = Time.now - respTime
      Rails.logger.info("Response Time: " + respTime.to_s)
      if(resp.success?)
        Rails.logger.info(Time.now.to_s + ': Obtained JSON for the ' + region.name + ' ' + bracket.name + ' ladder.')
        response = JSON.parse(resp.body)['rows']

        unchangedCharacterIds = Character.where(bracket_id: bracket.id, region_id: region.id).pluck(:id)

        groupTime = DateTime.now
        Character.transaction do
          response.each do |s|
            #create and/or select character
            character = Character.where(name: s['name'], realm_name: s['realmName'], bracket_id: bracket.id, region_id: region.id).first_or_initialize

            #check for recent match
            if(character.season_wins != nil && character.season_losses != nil && s['seasonWins'] > character.season_wins && (s['seasonWins'] - character.season_wins >= s['seasonLosses'] - character.season_losses))
              MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: true, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: s['rating'] - character.rating, rank_change: character.ranking - s['ranking'], retrieved_time: groupTime)
              Rails.logger.info("Found a recent match for : " + character.name.to_s)
            elsif (character.season_losses != nil && character.season_wins != nil && s['seasonLosses'] > character.season_losses)
              MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: false, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: character.rating - s['rating'], rank_change: s['ranking'] - character.ranking, retrieved_time: groupTime)
              Rails.logger.info("Found a recent match for : " + character.name.to_s)
            end

            #update character
            character.update_attributes(gender_id: s['genderId'], character_race_id: s['raceId'], character_class_id: s['classId'], character_spec_id: s['specId'], faction_id: s['factionId'], rating: s['rating'], ranking: s['ranking'], season_wins: s['seasonWins'], season_losses: s['seasonLosses'], weekly_wins: s['weeklyWins'], weekly_losses: s['weeklyLosses'])
            unchangedCharacterIds.delete(character.id)

          end
        end

        Rails.logger.info(Time.now.to_s + ': Done looping through JSON for ' + region.name + ' ' + bracket.name + ' ladder.')

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
