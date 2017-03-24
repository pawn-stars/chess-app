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

ActiveRecord::Schema.define(version: 20170321224803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.string   "result"
    t.integer  "winner"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "is_blacks_move"
    t.index ["winner"], name: "index_games_on_winner", using: :btree
  end

  create_table "moves", force: :cascade do |t|
    t.integer  "move_number"
    t.string   "move_type"
    t.integer  "game_id"
    t.integer  "piece_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "from_position", default: [],              array: true
    t.integer  "to_position",   default: [],              array: true
    t.index ["game_id"], name: "index_moves_on_game_id", using: :btree
    t.index ["piece_id"], name: "index_moves_on_piece_id", using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_participations_on_game_id", using: :btree
    t.index ["user_id", "game_id"], name: "index_participations_on_user_id_and_game_id", using: :btree
  end

  create_table "pieces", force: :cascade do |t|
    t.string   "type"
    t.integer  "row"
    t.integer  "col"
    t.boolean  "is_captured"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "game_id"
    t.boolean  "is_black"
    t.integer  "user_id"
    t.index ["game_id"], name: "index_pieces_on_game_id", using: :btree
  end

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
    t.string   "screen_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
