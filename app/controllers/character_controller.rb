class CharacterController < ApplicationController

  def list
  	@region = Region.find_by_abbr(params[:region].downcase)
    @bracket = Bracket.find_by_name(params[:bracket].downcase)
    # if(region && bracket)
    # 	@characters = Character.where(bracket_id: bracket.id, region_id: region.id).where.not(ranking: nil).order('ranking').all
    # end
  end

  def ladderJson
  	if(params[:region] && params[:bracket])
	  	region = Region.find_by_abbr(params[:region].downcase)
	    bracket = Bracket.find_by_name(params[:bracket].downcase)
	    if(region && bracket)
	    	characters = Character.where(bracket_id: bracket.id, region_id: region.id).where.not(ranking: nil).order('ranking').all
	    	render :json => characters
	    	return true
	    end
	end

	render :json => {error: 'Incorrect parameters.'}
    return false
  end
end