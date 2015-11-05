class ApiController < ApplicationController
  def get_character_classes
    require 'net/http'
    api_key = Rails.application.secrets.battlenet_api_key
    uri = URI('https://us.api.battle.net/wow/data/character/classes?locale=en_US&apikey=' + api_key)
    req = Net::HTTP.get(uri)

    @response = JSON.parse(req)["classes"]

    @response.each do |c|
      puts c['name']
      cclass = CharacterClass.find_by_name(c['name'])
      if(!cclass)
        cclass = CharacterClass.new
        cclass.id = c['id']
        cclass.name = c['name']
        cclass.mask = c['mask']
        cclass.power_type  =c['powerType']
        cclass.save
      end
    end

    @classes = CharacterClass.all
  end

  def updateCharacterTalents
    require 'net/http'
    api_key = Rails.application.secrets.battlenet_api_key
    uri = URI('https://us.api.battle.net/wow/data/talents?locale=en_US&apikey=' + api_key)
    req = Net::HTTP.get(uri)

    @response = JSON.parse(req)

    @response.each do |key, value|
      characterClass = CharacterClass.find_by_id(key)
      specslist = value['specs']
      specslist.each do |k|
        spec = CharacterSpec.find_by_name_and_character_class_id(k['name'], key)
        if(!spec)
          spec = CharacterSpec.new
          spec.name = k['name']
          spec.role = k['role']
          spec.background_image = k['backgroundImage']
          spec.icon = k['icon']
          spec.description = k['description']
          spec.order = k['order']
          spec.character_class = characterClass
          spec.save
        end
      end

      talentsList = value['talents']
      talentsList.each do |k|
        k.each do |h|
          h.each do |t|
            spell = Spell.find_by_id(t['spell']['id'])
            if(!spell)
              spell = Spell.new
              spell.id = t['spell']['id']
              spell.name = t['spell']['name']
              spell.icon = t['spell']['icon']
              spell.description = t['spell']['description']
              spell.range = t['spell']['range']
              spell.power_cost = t['spell']['powerCost']
              spell.cast_time = t['spell']['castTime']
              spell.cooldown = t['spell']['cooldown']
              spell.save
            end
            spell = Spell.find_by_id(t['spell']['id'])
            if(t['spec'])
              characterSpec = CharacterSpec.find_by_name_and_character_class_id(t['spec']['name'], key)
              talent = Talent.find_by_spell_id_and_character_spec_id(spell.id, characterSpec.id)
              if(!talent)
                talent = Talent.new
                talent.tier = t['tier']
                talent.column = t['column']
                talent.spell = spell
                talent.character_class = characterClass
                talent.character_spec = characterSpec
                talent.save
              end
            else
              talent = Talent.where(spell_id: spell.id, character_spec_id: nil)
              if(!talent)
                talent = Talent.new
                talent.tier = t['tier']
                talent.column = t['column']
                talent.spell = spell
                talent.character_class = characterClass
                talent.save
              end
            end
          end
        end
      end

      glyphsList = value['glyphs']
      glyphsList.each do |k|
        glyph = Glyph.find_by_id(k['glyph'])
        if(!glyph) 
          glyph = Glyph.new
          glyph.id = k['glyph']
          glyph.item_id = k['item']
          glyph.name = k['name']
          glyph.icon = k['icon']
          glyph.type_id = k['typeId']
          glyph.character_class = characterClass
          glyph.save
        end
      end
    end

    render :json => @response
  end

  def classes
    @classes = CharacterClass.all
  end

  def updateCharacterPvp
    ActiveRecord::Base.logger.level = 0

    require 'net/http'
    region = Region.find_by_abbr(params[:region])
    bracket = Bracket.find_by_name(params[:bracket])

    if(region && bracket)
      ladderStandings = LadderStanding.where(region_id: region.id, bracket_id: bracket.id)

      ladderStandings.each do |standing|
        pvpStat = PvpStat.where(character_id: standing.character.id, bracket_id: bracket.id).first_or_initialize
        pvpStat.update(ranking: standing.rank, rating: standing.rating, season_wins: standing.seasonWins, season_losses: standing.seasonLosses, weekly_wins: standing.weeklyWins, weekly_losses: standing.weeklyLosses)
      end
    end

    render :json => 'success'
  end

  def updateCharacterRaces
    require 'net/http'
    api_key = Rails.application.secrets.battlenet_api_key
    uri = URI('https://us.api.battle.net/wow/data/character/races?locale=en_US&apikey=' + api_key)
    req = Net::HTTP.get(uri)

    @response = JSON.parse(req)["races"]

    @response.each do |c|
      race = CharacterRace.find_by_name(c['name'])
      if(!race)
        race = CharacterRace.new
        race.id = c['id']
        race.name = c['name']
        race.mask = c['mask']
        race.faction  =c['side']
        race.save
      end
    end

    render :json => @response
  end

  def updateRealms
    require 'net/http'
    api_key = Rails.application.secrets.battlenet_api_key
    uri = URI('https://us.api.battle.net/wow/realm/status?locale=en_US&apikey=' + api_key)
    req = Net::HTTP.get(uri)

    @response = JSON.parse(req)["realms"]

    @response.each do |c|
      realm = Realm.find_by_name(c['name'])
      if(!realm)
        realm = Realm.new
        realm.name = c['name']
        realm.slug = c['slug']
        realm.realm_type  =c['type']
        realm.population  =c['population']
        realm.queue  =c['queue']
        realm.status  =c['status']
        realm.timezone  =c['timezone']
        realm.locale  =c['locale']
        realm.save
      end
    end

    render :json => @response
  end

  def updateLadder
    ActiveRecord::Base.logger.level = 1
    time = Time.now
    region = Region.find_by_abbr(params[:region].downcase)
    bracket = Bracket.find_by_name(params[:bracket].downcase)
    Rails.logger.info(Time.now.to_s + ': Starting cron job for the ' + region.name + ' ' + bracket.name + ' ladder.')

    if(region && bracket)
      api_key = Rails.application.secrets.battlenet_api_key
      resp = HTTParty.get('https://' + region.abbr + '.api.battle.net/wow/leaderboard/' + bracket.name + '?locale=' + region.locales.first.abbr + '&apikey=' + api_key, timeout: 30)
      if(resp.success?)
        Rails.logger.info(Time.now.to_s + ': Obtained JSON for the ' + region.name + ' ' + bracket.name + ' ladder.')
        response = JSON.parse(resp.body)['rows']

        unchangedCharacterIds = Character.where(bracket_id: bracket.id, region_id: region.id).pluck(:id)

        groupTime = DateTime.now
        Character.transaction do
          response.each do |s|

            #create and/or select character
            character = Character.where(name: s['name'], realm_name: s['realmName'], bracket_id: bracket.id, region_id: region.id).first_or_initialize

            #check for recent match
            if(character.season_wins != nil && s['seasonWins'] == character.season_wins + 1 && s['seasonLosses'] == character.season_losses && character.ranking != nil)
              MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: true, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: s['rating'] - character.rating, rank_change: character.ranking - s['ranking'], retrieved_time: groupTime)
            elsif (character.season_losses != nil && s['seasonLosses'] == character.season_losses + 1 && s['seasonWins'] == character.season_wins  && character.ranking != nil)
              MatchHistory.create(character_id: character.id, bracket_id: bracket.id, region_id: region.id, victory: false, old_rating: character.rating, new_rating: s['rating'], old_ranking: character.ranking, new_ranking: s['ranking'], rating_change: character.rating - s['rating'], rank_change: s['ranking'] - character.ranking, retrieved_time: groupTime)
            end

            #update character
            character.update_attributes(gender_id: s['genderId'], character_race_id: s['raceId'], character_class_id: s['classId'], character_spec_id: s['specId'], faction_id: s['factionId'], rating: s['rating'], ranking: s['ranking'], season_wins: s['seasonWins'], season_losses: s['seasonLosses'], weekly_wins: s['weeklyWins'], weekly_losses: s['weeklyLosses'])
            unchangedCharacterIds.delete(character.id)

          end
        end

        Rails.logger.info(Time.now.to_s + ': Done looping through JSON for ' + region.name + ' ' + bracket.name + ' ladder.')

        #clean up characters that fell off the ladder
        unchangedCharacters = Character.where.not(ranking: nil).where(id: unchangedCharacterIds, bracket_id: bracket.id, region_id: region.id)
        unchangedCharacters.each do |c|
          c.update_attributes(ranking: nil)
        end
      end
    end

    time = Time.now - time

    Rails.logger.info(groupTime.to_s + ': Cron job took ' + time.to_s + ' seconds to update the ' + region.name + ' ' + bracket.name + ' ladder.')

    render :json => "success"
  end

end