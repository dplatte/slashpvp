class CharacterController < ApplicationController

  def list
  	region = Region.find_by_abbr(params[:region])
    bracket = Bracket.find_by_name(params[:bracket])
    if(region && bracket)
    	@characters = Character.includes(:realm, :pvp_stats).where(pvp_stats: {bracket_id: bracket.id}).where.not(pvp_stats: {rating: nil, ranking: nil}).order('pvp_stats.ranking').all
    end
  end
end