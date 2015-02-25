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

ActiveRecord::Schema.define(version: 20150225112454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "arenas", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "mode"
    t.integer  "columns"
    t.integer  "rows"
    t.text     "layout"
    t.integer  "points_max",       default: 3
    t.integer  "points_min",       default: 3
    t.integer  "xp_join",          default: 1
    t.integer  "xp_kill",          default: 1
    t.integer  "credits_kill",     default: 10
    t.integer  "xp_win",           default: 1
    t.integer  "credits_win",      default: 10
    t.integer  "xp_survive",       default: 1
    t.integer  "credits_survive",  default: 10
    t.integer  "team_count",       default: 1
    t.integer  "players_max",      default: 1
    t.integer  "minutes_interval", default: 5
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "turn_limit"
    t.boolean  "active",           default: false
  end

  add_index "arenas", ["active"], name: "index_arenas_on_active", using: :btree
  add_index "arenas", ["name"], name: "index_arenas_on_name", using: :btree
  add_index "arenas", ["slug"], name: "index_arenas_on_slug", unique: true, using: :btree

  create_table "battle_bots", force: :cascade do |t|
    t.integer  "arena_id"
    t.integer  "unit_template_id"
    t.boolean  "filler",           default: false
    t.integer  "count",            default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "battle_bots", ["arena_id"], name: "index_battle_bots_on_arena_id", using: :btree
  add_index "battle_bots", ["unit_template_id"], name: "index_battle_bots_on_unit_template_id", using: :btree

  create_table "battles", force: :cascade do |t|
    t.integer  "arena_id"
    t.string   "outcome"
    t.text     "battle_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "battles", ["arena_id"], name: "index_battles_on_arena_id", using: :btree

  create_table "equipment", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "slot"
    t.integer  "accuracy"
    t.integer  "damage"
    t.integer  "range_min"
    t.integer  "range_max"
    t.integer  "bonus_hp",            default: 0
    t.integer  "bonus_evade",         default: 0
    t.integer  "bonus_move",          default: 0
    t.integer  "bonus_defense",       default: 0
    t.integer  "bonus_accuracy",      default: 0
    t.integer  "price",               default: 0
    t.integer  "points",              default: 1
    t.integer  "kill_requirement",    default: 0
    t.integer  "mission_requirement", default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "active",              default: false
    t.string   "icon_class"
  end

  add_index "equipment", ["active"], name: "index_equipment_on_active", using: :btree
  add_index "equipment", ["name"], name: "index_equipment_on_name", using: :btree
  add_index "equipment", ["slug"], name: "index_equipment_on_slug", unique: true, using: :btree

  create_table "unit_battle_outcomes", force: :cascade do |t|
    t.integer  "battle_id"
    t.integer  "unit_id"
    t.string   "outcome"
    t.integer  "xp",         default: 0
    t.integer  "credits",    default: 0
    t.integer  "kills",      default: 0
    t.text     "details"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "assists",    default: 0
  end

  add_index "unit_battle_outcomes", ["battle_id"], name: "index_unit_battle_outcomes_on_battle_id", using: :btree
  add_index "unit_battle_outcomes", ["unit_id"], name: "index_unit_battle_outcomes_on_unit_id", using: :btree

  create_table "unit_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "price",               default: 0
    t.integer  "kill_requirement",    default: 0
    t.integer  "mission_requirement", default: 0
    t.integer  "hp",                  default: 1
    t.integer  "evade",               default: 10
    t.integer  "move",                default: 3
    t.integer  "defense",             default: 0
    t.integer  "weapon_default_id"
    t.integer  "weapon_pt_limit",     default: 1
    t.integer  "armor_default_id"
    t.integer  "armor_pt_limit",      default: 1
    t.integer  "mobility_default_id"
    t.integer  "mobility_pt_limit",   default: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "points",              default: 3
    t.boolean  "active",              default: false
    t.string   "icon_class"
  end

  add_index "unit_templates", ["active"], name: "index_unit_templates_on_active", using: :btree
  add_index "unit_templates", ["armor_default_id"], name: "index_unit_templates_on_armor_default_id", using: :btree
  add_index "unit_templates", ["mobility_default_id"], name: "index_unit_templates_on_mobility_default_id", using: :btree
  add_index "unit_templates", ["name"], name: "index_unit_templates_on_name", using: :btree
  add_index "unit_templates", ["slug"], name: "index_unit_templates_on_slug", unique: true, using: :btree
  add_index "unit_templates", ["weapon_default_id"], name: "index_unit_templates_on_weapon_default_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.integer  "unit_template_id"
    t.integer  "arena_id"
    t.string   "attack_strategy"
    t.string   "move_strategy"
    t.integer  "xp",               default: 0
    t.integer  "kills",            default: 0
    t.integer  "missions",         default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "units", ["arena_id"], name: "index_units_on_arena_id", using: :btree
  add_index "units", ["unit_template_id"], name: "index_units_on_unit_template_id", using: :btree
  add_index "units", ["user_id"], name: "index_units_on_user_id", using: :btree

  create_table "user_equipments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "equipment_id"
    t.integer  "unit_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_equipments", ["equipment_id"], name: "index_user_equipments_on_equipment_id", using: :btree
  add_index "user_equipments", ["unit_id"], name: "index_user_equipments_on_unit_id", using: :btree
  add_index "user_equipments", ["user_id"], name: "index_user_equipments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.integer  "credits",                default: 0
    t.integer  "total_xp",               default: 0
    t.integer  "total_missions",         default: 0
    t.integer  "total_kills",            default: 0
    t.integer  "gold",                   default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "battle_bots", "arenas"
  add_foreign_key "battle_bots", "unit_templates"
  add_foreign_key "battles", "arenas"
  add_foreign_key "unit_battle_outcomes", "battles"
  add_foreign_key "unit_battle_outcomes", "units"
  add_foreign_key "units", "arenas"
  add_foreign_key "units", "unit_templates"
  add_foreign_key "units", "users"
  add_foreign_key "user_equipments", "equipment"
  add_foreign_key "user_equipments", "units"
  add_foreign_key "user_equipments", "users"
end
