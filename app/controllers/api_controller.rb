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

    region = Region.find_by_abbr(params[:region].downcase)
    if(region)
      require 'net/http'
      api_key = Rails.application.secrets.battlenet_api_key
      uri = URI(region.domain + '/wow/realm/status?locale=' + region.locales.first.abbr + '&apikey=' + api_key)
      req = Net::HTTP.get(uri)

      @response = JSON.parse(req)["realms"]

      if(@response != nil)
        @response.each do |c|
          realm = Realm.find_by_name_and_region_id(c['name'], region.id)
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
            realm.region_id = region.id
            realm.save
          end
        end
      end
    end

    render :json => @response
  end

  def updateLadder
    ActiveRecord::Base.logger.level = 1
    time = Time.now
    region = Region.find_by_abbr(params[:region].downcase)
    bracket = Bracket.find_by_name(params[:bracket].downcase)

    if(region && bracket)
      Character.updateLadder(region.abbr,bracket.name)
    end

    render :json => "success"
  end

end