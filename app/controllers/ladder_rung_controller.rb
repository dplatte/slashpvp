class LadderRungController < ApplicationController

  def list
    @ladderRungs = LadderRung.order('ladder_rungs.ranking ASC').all
  end
end