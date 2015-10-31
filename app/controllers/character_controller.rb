class CharacterController < ApplicationController

  def list
    @region = current_region
    @bracket = Bracket.find_by_name(params[:bracket].downcase)
    if(!@bracket)
      return not_found
    end

    @classes = CharacterClass.all
  end

  def recent
    @region = current_region
    @bracket = Bracket.find_by_name(params[:bracket].downcase)
    if(!@bracket)
      return not_found
    end

    @classes = CharacterClass.all
  end

  def ladderJson
    bracket = current_bracket
    region = current_region
  	characters = Character.where(bracket_id: bracket.id, region_id: region.id).where.not(ranking: nil).order('ranking').all
  	render :json => characters
  	return true
  end

  def recentJson
    if(params[:bracket])
      bracket = Bracket.find_by_name(params[:bracket].downcase)
      region = current_region
      if(params[:region])
        region = Region.find_by_abbr(params[:region].downcase)
      end
      if(region && bracket)

        characters = Character.joins(:match_histories).where('characters.bracket_id = ?, characters.region_id = ?, characters.ranking != ?, match_histories.retrieved_time > ?', bracket.id, region.id, nil, 1.hour.ago)
        render :json => characters
        return true
      end
    end

    render :json => {error: 'Incorrect parameters.'}
    return false
  end

end