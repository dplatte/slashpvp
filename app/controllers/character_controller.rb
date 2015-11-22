class CharacterController < ApplicationController

  def list
    @region = current_region
    @bracket = current_bracket
    @classes = CharacterClass.all
    
  end

  def recent
    @region = current_region
    @bracket = current_bracket
    @classes = CharacterClass.all
  end

  def ladderJson
    bracket = current_bracket
    region = current_region
  	characters = Character.where(bracket_id: bracket.id, region_id: region.id).where.not(ranking: nil).order('ranking').all
  	render :json => characters
  end

  def recentJson
    bracket = current_bracket
    region = current_region
    #1.hour.ago
    histories = MatchHistory.includes(:character).where('characters.bracket_id = ? and characters.region_id = ?', bracket.id, region.id).where.not('characters.ranking' => nil).references(:character).order('match_histories.retrieved_time DESC, characters.ranking ASC').limit(2000)
    #characters = Character.joins(:match_histories).where().order('characters.ranking DESC, match_histories.retrieved_time ASC')
    
    uniqueCharacterIds = Array.new
    duplicateHistoryIds = Array.new

    Rails.logger.info(histories[0])
    # histories.each do |history|
    #   if(!uniqueCharacterIds.include?(history.character.id))
    #     uniqueCharacterIds.push(history.character.id)
    #   else
    #     histories = histories.reject{|h| h.id == history.id}
    #   end
    # end

    render :json => histories.to_json(:include => :character)
    #return true
  end

end