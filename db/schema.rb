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

ActiveRecord::Schema[8.0].define(version: 2025_03_07_190751) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "redirections", force: :cascade do |t|
    t.string "target_key", null: false
    t.string "secret_key", null: false
    t.string "url_target", null: false
    t.datetime "expire_at"
    t.integer "requisition_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["secret_key"], name: "index_redirections_on_secret_key", unique: true
    t.index ["target_key", "expire_at"], name: "index_redirections_on_target_key_and_expire_at"
    t.index ["target_key"], name: "index_redirections_on_target_key", unique: true
    t.index ["url_target", "expire_at"], name: "index_redirections_on_url_target_and_expire_at"
  end

  create_table "requisitions", force: :cascade do |t|
    t.bigint "redirection_id"
    t.string "ip"
    t.string "device"
    t.string "os"
    t.string "browser"
    t.string "location"
    t.string "action_type"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["redirection_id"], name: "index_requisitions_on_redirection_id"
  end

  add_foreign_key "requisitions", "redirections"
end
