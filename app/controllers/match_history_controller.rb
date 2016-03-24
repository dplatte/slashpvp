class MatchHistoryController < ApplicationController

  def list
  	Rails.logger.level = 1
  	region = Region.find_by_abbr('us')
    bracket = Bracket.find_by_name('3v3')
    if(region && bracket)
    	@histories = MatchHistory.from("(SELECT mh.character_id, mh.victory, mh.rating_change, mh.rank_change, mh.bracket_id, mh.region_id, mh.old_rating, mh.new_rating, mh.old_ranking, mh.new_ranking, mh.retrieved_time, c.ranking, c.character_spec_id, c.character_race_id, c.character_class_id, c.gender_id, c.name  FROM match_histories mh INNER JOIN characters c on mh.character_id = c.id ORDER BY mh.retrieved_time DESC) as match_histories").where(retrieved_time: 1.hour.ago..DateTime.now, bracket_id: 2, region_id: 1).where.not(ranking: nil).group('character_id').order("retrieved_time DESC, ranking ASC")
    	Rails.logger.info('histories size: ' + @histories.length.to_s)
    end

    render :json => @histories
  end

  def character
    @character = Character.find_by_id(params[:character_id])
    @realm = Realm.find_by_name(@character.realm_name)
    @region = Region.find_by_id(@character.region_id)
    @faction = Faction.find_by_id(@character.faction_id)
  end

  def characterJson
    histories = MatchHistory.includes(:character).where(character_id: params[:character_id], region_id: current_region.id, bracket_id: current_bracket.id).order('match_histories.retrieved_time DESC')
  
    render :json => histories.to_json(:includes => :character)
  end
end