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

ActiveRecord::Schema[7.0].define(version: 1) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "こころ", primary_key: "こころ_no", force: :cascade do |t|
    t.string "name"
    t.integer "ちから"
  end

  create_table "こころ効果", primary_key: "こころ効果", force: :cascade do |t|
    t.integer "こころ_no"
    t.string "効果"
    t.index ["こころ_no", "効果"], name: "index_こころ効果_on_こころ_no_and_効果", unique: true
  end

  create_table "効果", primary_key: "効果", id: :string, force: :cascade do |t|
  end

  add_foreign_key "こころ効果", "\"こころ\"", column: "こころ_no", primary_key: "こころ_no"
  add_foreign_key "こころ効果", "\"効果\"", column: "効果", primary_key: "効果"
end
