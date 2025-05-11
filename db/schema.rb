# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_25_193956) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "animes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shikimori_id"
    t.string "title"
    t.string "anime_img"
    t.string "dtype"
    t.string "date"
    t.string "status"
    t.float "score"
    t.string "id_anime"
    t.string "link"
    t.string "title_orig"
    t.string "other_title"
    t.integer "last_season"
    t.integer "last_episode"
    t.integer "episodes_count"
    t.string "kinopoisk_id"
    t.string "worldart_link"
    t.string "imdb_id"
    t.string "mdl_id"
    t.string "quality"
    t.boolean "camrip"
    t.boolean "lgbt"
    t.text "blocked_countries", default: [], array: true
    t.jsonb "blocked_seasons", default: {}
    t.text "screenshots", default: [], array: true
    t.jsonb "translation", default: {}
    t.jsonb "genres", default: {}
    t.string "rating_mpaa"
    t.string "next_episode_at"
    t.jsonb "studios", default: {}
    t.jsonb "videos", default: {}
    t.integer "duration"
    t.string "description"
    t.string "aired_at"
    t.string "released_at"
    t.integer "minimal_age"
    t.string "not_blocked_in"
    t.boolean "not_blocked_for_me"
    t.jsonb "material_data"
    t.integer "age_limit"
    t.index ["title"], name: "index_animes_on_title", opclass: :gin_trgm_ops, using: :gin
  end
end
