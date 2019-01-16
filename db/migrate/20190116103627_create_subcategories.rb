class CreateSubcategories < ActiveRecord::Migration[5.0]
  def change
    create_table :subcategories do |t|
      t.string :name
      t.text :description
      t.references :category, foreign_key: true
      t.string :market_session
      t.string :logo

      t.timestamps
    end
  end
end
