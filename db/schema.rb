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

ActiveRecord::Schema.define(version: 20180808085137) do

  create_table "improvements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "short_description",  limit: 65535
    t.text     "description",        limit: 65535
    t.string   "address"
    t.string   "address_comp"
    t.integer  "limit_volunteers"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "knowledge_required", limit: 65535
    t.text     "support_materials",  limit: 65535
    t.string   "status"
    t.integer  "social_entity_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "people_benefited"
    t.index ["social_entity_id"], name: "index_improvements_on_social_entity_id", using: :btree
  end

  create_table "occupation_areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_entities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "about_us",           limit: 65535
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "email_contact"
    t.string   "site"
    t.string   "address"
    t.integer  "user_id"
    t.integer  "target_audience_id"
    t.integer  "occupation_area_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "you_are_a"
    t.string   "facebook_url"
    t.string   "address_comp"
    t.string   "cnpj_no"
    t.index ["occupation_area_id"], name: "index_social_entities_on_occupation_area_id", using: :btree
    t.index ["target_audience_id"], name: "index_social_entities_on_target_audience_id", using: :btree
    t.index ["user_id"], name: "index_social_entities_on_user_id", using: :btree
  end

  create_table "target_audiences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "description",  limit: 65535
    t.boolean  "done",                       default: false
    t.datetime "deadline"
    t.integer  "user_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "task_type_id"
    t.index ["task_type_id"], name: "index_tasks_on_task_type_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                                default: "",      null: false
    t.string   "encrypted_password",                   default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "auth_token"
    t.string   "provider",                             default: "email", null: false
    t.string   "uid",                                  default: "",      null: false
    t.string   "name"
    t.text     "tokens",                 limit: 65535
    t.string   "user_type"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "volunteer_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "volunteer_id"
    t.integer  "improvement_id"
    t.boolean  "attendance"
    t.integer  "rate_volunteer"
    t.integer  "rate_improvement"
    t.integer  "rate_social_entity"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["improvement_id"], name: "index_volunteer_lists_on_improvement_id", using: :btree
    t.index ["volunteer_id"], name: "index_volunteer_lists_on_volunteer_id", using: :btree
  end

  create_table "volunteers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "address"
    t.string   "address_comp"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_volunteers_on_user_id", using: :btree
  end

  add_foreign_key "improvements", "social_entities"
  add_foreign_key "social_entities", "occupation_areas"
  add_foreign_key "social_entities", "target_audiences"
  add_foreign_key "social_entities", "users"
  add_foreign_key "tasks", "task_types"
  add_foreign_key "tasks", "users"
  add_foreign_key "volunteer_lists", "improvements"
  add_foreign_key "volunteer_lists", "volunteers"
  add_foreign_key "volunteers", "users"
end
