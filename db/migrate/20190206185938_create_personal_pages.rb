class CreatePersonalPages < ActiveRecord::Migration[5.0]
  def change
    create_table :personal_pages do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
