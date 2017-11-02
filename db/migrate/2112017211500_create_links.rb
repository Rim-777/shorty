class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :shortcode,  null: false, index: {unique: true}
      t.integer :redirect_count, default: 0
      t.timestamps null: false
    end
  end
end