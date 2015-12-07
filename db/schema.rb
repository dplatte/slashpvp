# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151117063508) do

  create_table "brackets", force: true do |t|
    t.string   "name"
    t.integer  "player_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
  end

  create_table "character_classes", force: true do |t|
    t.integer  "mask"
    t.string   "power_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_races", force: true do |t|
    t.integer  "mask"
    t.string   "faction"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "character_specs", force: true do |t|
    t.string   "name"
    t.string   "role"
    t.string   "background_image"
    t.string   "icon"
    t.string   "description"
    t.integer  "order"
    t.integer  "character_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_specs", ["character_class_id"], name: "index_character_specs_on_character_class_id", using: :btree

  create_table "characters", force: true do |t|
    t.string   "name"
    t.integer  "character_race_id"
    t.integer  "character_class_id"
    t.integer  "character_spec_id"
    t.integer  "faction_id"
    t.integer  "gender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "realm_name"
    t.integer  "rating"
    t.integer  "ranking"
    t.integer  "season_wins"
    t.integer  "season_losses"
    t.integer  "weekly_wins"
    t.integer  "weekly_losses"
    t.integer  "bracket_id"
    t.integer  "region_id"
  end

  add_index "characters", ["bracket_id"], name: "index_characters_on_bracket_id", using: :btree
  add_index "characters", ["character_class_id"], name: "index_characters_on_character_class_id", using: :btree
  add_index "characters", ["character_race_id"], name: "index_characters_on_character_race_id", using: :btree
  add_index "characters", ["character_spec_id"], name: "index_characters_on_character_spec_id", using: :btree
  add_index "characters", ["faction_id"], name: "index_characters_on_faction_id", using: :btree
  add_index "characters", ["gender_id"], name: "index_characters_on_gender_id", using: :btree
  add_index "characters", ["name", "realm_name", "bracket_id", "region_id"], name: "by_name_realm_bracket_region", unique: true, using: :btree
  add_index "characters", ["region_id"], name: "index_characters_on_region_id", using: :btree

  create_table "factions", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genders", id: false, force: true do |t|
    t.integer  "id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "glyphs", force: true do |t|
    t.integer  "glyph_id"
    t.integer  "item_id"
    t.string   "name"
    t.string   "icon"
    t.integer  "type_id"
    t.integer  "character_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glyphs", ["character_class_id"], name: "index_glyphs_on_character_class_id", using: :btree

  create_table "locales", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  add_index "locales", ["region_id"], name: "index_locales_on_region_id", using: :btree

  create_table "match_histories", force: true do |t|
    t.boolean  "victory"
    t.integer  "rating_change"
    t.integer  "rank_change"
    t.integer  "region_id"
    t.integer  "bracket_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_rating"
    t.integer  "new_rating"
    t.integer  "old_ranking"
    t.integer  "new_ranking"
    t.datetime "retrieved_time"
    t.integer  "season_wins"
    t.integer  "season_losses"
  end

  add_index "match_histories", ["bracket_id"], name: "index_match_histories_on_bracket_id", using: :btree
  add_index "match_histories", ["character_id"], name: "index_match_histories_on_character_id", using: :btree
  add_index "match_histories", ["region_id"], name: "index_match_histories_on_region_id", using: :btree

  create_table "realms", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "realm_type"
    t.string   "population"
    t.boolean  "queue"
    t.boolean  "status"
    t.string   "timezone"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
  end

  create_table "roster_slots", force: true do |t|
    t.integer  "team_id"
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roster_slots", ["character_id"], name: "index_roster_slots_on_character_id", using: :btree
  add_index "roster_slots", ["team_id", "character_id"], name: "index_roster_slots_on_team_id_and_character_id", unique: true, using: :btree
  add_index "roster_slots", ["team_id"], name: "index_roster_slots_on_team_id", using: :btree

  create_table "spells", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.text     "description"
    t.string   "range"
    t.string   "power_cost"
    t.string   "cast_time"
    t.string   "cooldown"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "talents", force: true do |t|
    t.integer  "tier"
    t.integer  "column"
    t.integer  "character_class_id"
    t.integer  "spell_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_spec_id"
  end

  add_index "talents", ["character_class_id"], name: "index_talents_on_character_class_id", using: :btree
  add_index "talents", ["character_spec_id"], name: "index_talents_on_character_spec_id", using: :btree
  add_index "talents", ["spell_id"], name: "index_talents_on_spell_id", using: :btree

  create_table "teams", force: true do |t|
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "probability"
    t.integer  "team_composition_id"
    t.datetime "last_played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", force: true do |t|
    t.string   "name"
    t.decimal  "percentage",     precision: 10, scale: 0
    t.integer  "rating"
    t.integer  "ranking"
    t.integer  "lowest_ranking"
    t.integer  "bracket_id"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titles", ["bracket_id"], name: "index_titles_on_bracket_id", using: :btree
  add_index "titles", ["region_id"], name: "index_titles_on_region_id", using: :btree

end
