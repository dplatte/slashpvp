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
    races = CharacterRace.all
    specs = CharacterSpec.all
    classes = CharacterClass.all
    factions = Faction.all

    factionsArray = []
    factions.each do |faction|
      factionsArray.push(faction.name.capitalize)
    end

    response = {characters: characters, races: races, specs: specs, classes: classes, factions: factionsArray}
  	
    render :json => response


  end

  def recentJson
    bracket = current_bracket
    region = current_region
    #1.hour.ago
    histories = MatchHistory.includes(:character).where('characters.bracket_id = ? and characters.region_id = ? and match_histories.retrieved_time > ?', bracket.id, region.id, 1.hour.ago).where.not('characters.ranking' => nil).order('match_histories.retrieved_time DESC, characters.ranking ASC').all
    #characters = Character.joins(:match_histories).where().order('characters.ranking DESC, match_histories.retrieved_time ASC')
    
    uniqueCharacterIds = Array.new
    duplicateHistoryIds = Array.new

    histories.each do |history|
      if(!uniqueCharacterIds.include?(history.character.id))
        uniqueCharacterIds.push(history.character.id)
      else
        histories = histories.reject{|h| h.id == history.id}
      end
    end

    races = CharacterRace.all
    specs = CharacterSpec.all
    classes = CharacterClass.all
    factions = Faction.all

    factionsArray = []
    factions.each do |faction|
      factionsArray.push(faction.name.capitalize)
    end

    response = {characters: histories.to_json(:include => :character), races: races, specs: specs, classes: classes, factions: factionsArray}

    render :json => response
    #return true
  end

end