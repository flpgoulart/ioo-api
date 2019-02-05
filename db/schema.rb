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

ActiveRecord::Schema.define(version: 20190205175633) do

  create_table "business_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "cnpj"
    t.string "insce"
    t.string "inscm"
    t.string "city_name"
    t.string "uf"
    t.string "email"
    t.integer "ddd_phone"
    t.integer "phone"
    t.integer "ddd_mobile"
    t.integer "mobile"
    t.string "address_name"
    t.string "cep"
    t.string "plan"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_business_accounts_on_user_id"
  end

  create_table "businesses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "about_us"
    t.string "url_site"
    t.string "url_facebook"
    t.text "contact_info"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "campaigns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "disclaimer"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "cep_begin"
    t.integer "cep_end"
    t.string "uf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "brand_name"
    t.integer "product_id"
    t.integer "campaign_id"
    t.text "disclaimer"
    t.string "status"
    t.integer "unit_measure_id"
    t.float "product_value", limit: 24
    t.float "offer_value", limit: 24
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_offers_on_campaign_id"
    t.index ["product_id"], name: "index_offers_on_product_id"
    t.index ["unit_measure_id"], name: "index_offers_on_unit_measure_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "products", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "logo_default"
    t.integer "subcategory_id"
    t.text "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subcategory_id"], name: "index_products_on_subcategory_id"
  end

  create_table "shopping_list_offers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shopping_list_id"
    t.integer "offer_id"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_shopping_list_offers_on_offer_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_offers_on_shopping_list_id"
    t.index ["user_id"], name: "index_shopping_list_offers_on_user_id"
  end

  create_table "shopping_lists", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shopping_lists_on_user_id"
  end

  create_table "store_campaigns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "store_id"
    t.integer "campaign_id"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_store_campaigns_on_campaign_id"
    t.index ["store_id"], name: "index_store_campaigns_on_store_id"
    t.index ["user_id"], name: "index_store_campaigns_on_user_id"
  end

  create_table "store_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "store_type_id"
    t.integer "business_id"
    t.integer "city_id"
    t.string "cep"
    t.string "address_name"
    t.string "contact_info"
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_stores_on_business_id"
    t.index ["city_id"], name: "index_stores_on_city_id"
    t.index ["store_type_id"], name: "index_stores_on_store_type_id"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "subcategories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.integer "category_id"
    t.string "market_session"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "unit_measures", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "name"
    t.text "tokens"
    t.string "user_type"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "business_accounts", "users"
  add_foreign_key "businesses", "users"
  add_foreign_key "campaigns", "users"
  add_foreign_key "offers", "campaigns"
  add_foreign_key "offers", "products"
  add_foreign_key "offers", "unit_measures"
  add_foreign_key "offers", "users"
  add_foreign_key "products", "subcategories"
  add_foreign_key "shopping_list_offers", "offers"
  add_foreign_key "shopping_list_offers", "shopping_lists"
  add_foreign_key "shopping_list_offers", "users"
  add_foreign_key "shopping_lists", "users"
  add_foreign_key "store_campaigns", "campaigns"
  add_foreign_key "store_campaigns", "stores"
  add_foreign_key "store_campaigns", "users"
  add_foreign_key "stores", "businesses"
  add_foreign_key "stores", "cities"
  add_foreign_key "stores", "store_types"
  add_foreign_key "stores", "users"
  add_foreign_key "subcategories", "categories"
end
