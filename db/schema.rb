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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120609233825) do

  create_table "amounts", :force => true do |t|
    t.integer  "recipe_id",     :null => false
    t.integer  "ingredient_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "amount"
    t.string   "units"
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "uid"
    t.string   "access_token"
  end

  create_table "ingredients", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ingredients_recipes", :id => false, :force => true do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
  end

  add_index "ingredients_recipes", ["ingredient_id", "recipe_id"], :name => "index_ingredients_recipes_on_ingredient_id_and_recipe_id"

  create_table "personal_recipe_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.float    "rating"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "favorite",   :default => false
  end

  create_table "recipes", :force => true do |t|
    t.string   "name",                           :null => false
    t.text     "desc",                           :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.float    "rating",        :default => 0.0
    t.string   "url_slug",                       :null => false
    t.string   "image"
    t.integer  "total_ratings", :default => 0
    t.integer  "created_by",    :default => 1,   :null => false
    t.string   "difficulty"
    t.integer  "serving_from"
    t.integer  "serving_to"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
  end

end
