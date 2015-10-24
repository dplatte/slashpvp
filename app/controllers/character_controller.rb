class CharacterController < ApplicationController

  def list
  	region = Region.find_by_abbr(params[:region])
    bracket = Bracket.find_by_name(params[:bracket])
    if(region && bracket)
    	@characters = Character.where(bracket_id: bracket.id, region_id: region.id).where.not(ranking: nil).order('ranking').all
    end
  end
end