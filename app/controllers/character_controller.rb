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
    characters = Character.joins(:match_histories).where('characters.bracket_id = ?, characters.region_id = ?, characters.ranking != ?, match_histories.retrieved_time > ?', bracket.id, region.id, nil, 1.hour.ago)
    
    uniqueCharacters = Array.new

    characters.each do |character|
      if(!uniqueCharacters.include? character)
        uniqueCharacters.push(character)
      end
    end

    render :json => uniqueCharacters
    return true
  end

end