class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :logo_default
      t.references :subcategory, foreign_key: true
      t.text :keywords

      t.timestamps
    end
  end
end
