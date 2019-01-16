class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.text :about_us
      t.string :url_site
      t.string :url_facebook
      t.text :contact_info
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
