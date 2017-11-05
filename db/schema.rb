ActiveRecord::Schema.define(version: 2112017211500) do
  enable_extension "plpgsql"

  create_table "links", force: :cascade do |t|
    t.string   "url",                        null: false
    t.string   "shortcode",                  null: false
    t.integer  "redirect_count", default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["shortcode"], name: "index_links_on_shortcode", unique: true, using: :btree
  end
end
