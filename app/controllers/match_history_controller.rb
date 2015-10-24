class MatchHistoryController < ApplicationController

  def list
  	Rails.logger.level = 1
  	region = Region.find_by_abbr(params[:region])
    bracket = Bracket.find_by_name(params[:bracket])
    if(region && bracket)
    	@histories = MatchHistory.from("(SELECT mh.character_id, mh.victory, mh.rating_change, mh.rank_change, mh.old_rating, mh.new_rating, mh.old_ranking, mh.new_ranking, mh.retrieved_time, c.ranking FROM match_histories mh inner join characters c on mh.character_id = c.id ORDER BY mh.retrieved_time DESC) as match_histories").where(retrieved_time: 1.hour.ago..DateTime.now).group('character_id').order("retrieved_time DESC, ranking ASC")
    	Rails.logger.info('histories size: ' + @histories.length.to_s)
    end
  end
end